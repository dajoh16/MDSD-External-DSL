package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.quickCheckApi.NoAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.PostConjunction
import org.xtext.mdsd.external.quickCheckApi.PostDisjunction
import org.xtext.mdsd.external.quickCheckApi.GET
import org.xtext.mdsd.external.quickCheckApi.DELETE
import org.xtext.mdsd.external.quickCheckApi.PATCH
import org.xtext.mdsd.external.quickCheckApi.PUT
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.Body
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.BodyCondition
import org.xtext.mdsd.external.quickCheckApi.CodeCondition
import org.xtext.mdsd.external.quickCheckApi.RequestOp
import org.xtext.mdsd.external.quickCheckApi.VariableUse
import org.xtext.mdsd.external.quickCheckApi.Json

class QCRunCmd {
	def initRun_cmd(Test test ) {
		'''
		let run_cmd cmd state sut = match cmd with
			«FOR request : test.requests»
			| «QCUtils.compilePatternMatchingRequest(request)» «request.compileRunCmd»
			«ENDFOR»
		'''
	}
	
	def CharSequence determineIndex(Action action){
		if (action instanceof DeleteAction || action instanceof UpdateAction || action instanceof NoAction){
			'''ix ->'''
		} else {
			''' ->'''
		}
	}
	
	def CharSequence createHttpCall(Request request) {
		if (request.url.domain.requestID === null) {			
			'''
				let code,content = Http.«request.method.compileMethod» «QCUtils.firstCharLowerCase(request.name)»URL "«IF request.body !== null»«request.body.compileBody»«ENDIF»" in
			'''
		} else {
			'''
			let id = lookupSutItem ix !sut in
				let code,content = Http.«request.method.compileMethod» («QCUtils.firstCharLowerCase(request.name)»URL^"/"^id) "«IF request.body !== null»«request.body.compileBody»«ENDIF»" in
			'''
		}
		
	}
	
	def CharSequence compileBody(Body body) {
		QCUtils.compileJsonUse(body.value)
	}
	
	
	
	def dispatch CharSequence compileMethod(GET get) {
		'''get'''
	}
	def dispatch CharSequence compileMethod(POST get) {
		'''post'''
	}
	def dispatch CharSequence compileMethod(PUT get) {
		'''put'''
	}
	def dispatch CharSequence compileMethod(PATCH get) {
		'''patch'''
	}
	def dispatch CharSequence compileMethod(DELETE get) {
		'''delete'''
	}
	
	
	def CharSequence compileRunCmd(Request request){
		'''
		«request.createHttpCall»
		«request.action.compileAction()»
		«request.postconditions.compilePostCondition»
		'''
	}
	
	def dispatch CharSequence compilePostCondition(PostConjunction and) {
		'''
		(«and.left.compilePostCondition») && («and.right.compilePostCondition»)
		'''
	}
	
	def dispatch CharSequence compilePostCondition(PostDisjunction or) {
		'''(«or.left.compilePostCondition») || («or.right.compilePostCondition»)'''
	}
	
	def dispatch CharSequence compilePostCondition(CodeCondition condition) {
		'''«condition.requestOp.compileRequestOp» (code == «condition.statusCode.code»)'''
	}
	
	def dispatch CharSequence compilePostCondition(BodyCondition condition) {
		if(QCJsonUtils.isIdInJsonUse(condition.requestValue.body)){
			'''
			let extractedState = lookupItem ix state in
				let id = lookupSutItem ix !sut in
					let stateJson = Yojson.Basic.from_string extractedState in
						let sutJson = Yojson.Basic.from_string («QCJsonUtils.extractIdJsonFromJsonUse(condition.requestValue.body)») in
							let combined = Yojson.Basic.Util.combine stateJson sutJson
							«IF QCJsonUtils.isIgnoreInJsonUse(condition.requestValue.body)»
							let filteredContent = ignore«QCUtils.getVariableDefName(condition.requestValue.body)» content in
							«condition.requestOp.compileRequestOp» (String.compare (Yojson.Basic.to_string combined) (Yojson.Basic.to_string filteredContent) == 0)
							«ELSE»
							«condition.requestOp.compileRequestOp» (String.compare (Yojson.Basic.to_string combined) (Yojson.Basic.to_string content) == 0)
							«ENDIF»
			'''
			
		} else {
			'''«condition.requestOp.compileRequestOp» (String.compare (Yojson.Basic.to_string «QCUtils.compileJsonUse(condition.requestValue.body)») (Yojson.Basic.to_string content) == 0)'''
		}
	}
	
	def CharSequence compileRequestOp(RequestOp op){
		if(op.notOp === null || op.notOp == ""){
			''''''
		} else {
			'''not '''
		}
	}
	
	
	
	def dispatch CharSequence compileAction(CreateAction action) {
		if(QCJsonUtils.isIdInJsonUse(action.value)){
		'''
		let id = content «QCJsonUtils.extractId(action.value)» in
			sut := !sut@[id];
		'''
		} else {
		''''''
		}
	}
	def dispatch CharSequence compileAction(DeleteAction action) {
		'''
	    let pos = getPos ix !sut in
	    	sut := remove_item pos !sut;
		'''
	}
	def dispatch CharSequence compileAction(UpdateAction action) {
		// Doesn't update sut so should not do anything
		''''''
	}
	def dispatch CharSequence compileAction(NoAction action) {
		// Doesn't update sut so should not do anything
		''''''
	}	
}