package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.generator.QCUtils
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.VariableUse
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.IdValue
import org.xtext.mdsd.external.quickCheckApi.RandStrValue
import org.xtext.mdsd.external.quickCheckApi.RandIntValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.IgnoreValue

class QCArbCmd {
	
	def initArb_cmd(Test test ) {
		
		'''
		let arb_cmd state = 
		  let int_gen = Gen.oneof [Gen.small_int] in
		  let str_gen = Gen.oneof [Gen.string_gen] in
		  if state = [] then
		    QCheck.make ~print:show_cmd
		    (Gen.oneof [
		    «FOR request: QCUtils.filterRequireNoIndex(test.requests) SEPARATOR ";"» 
		    «request.compileNoIndexRequestGen»
		    «ENDFOR»
		    ])
		    
		  else
		    QCheck.make ~print:show_cmd
		      (Gen.oneof [
			      		  «FOR request: test.requests SEPARATOR ";"»
			      		  «request.compileRequestGen»
						  «ENDFOR»
		                 ])
		'''
	}
	
	private def CharSequence compileRequestGen(Request request){
		'''
		«IF QCUtils.requireIndex(request) && request.body === null» 
		Gen.map (fun i -> «QCUtils.toUpperCaseFunction(request.name)» i) int_gen
		«ELSEIF QCUtils.requireIndex(request) && (request.body !== null && QCJsonUtils.containsRandomGenerationJsonUse(request.body.value))» 
			«IF countInput(request) == 1»
			Gen.map2 (fun i j -> «QCUtils.toUpperCaseFunction(request.name)» (i,j)) int_gen «compileUseRandomGen(request)»
			«ELSEIF countInput(request) == 2»
			Gen.map3 (fun i j x -> «QCUtils.toUpperCaseFunction(request.name)» (i,j,x)) int_gen «compileUseRandomGen(request)»
			«ENDIF»
		«ELSEIF !QCUtils.requireIndex(request)» 
			«request.compileNoIndexRequestGen»
		«ENDIF»
		'''
	}
	
	private def CharSequence compileNoIndexRequestGen(Request request){
		'''
		«IF (request.body !== null && QCJsonUtils.containsRandomGenerationJsonUse(request.body.value))»
				«IF countInput(request) == 1»
				Gen.map (fun i -> «QCUtils.toUpperCaseFunction(request.name)» i) «compileUseRandomGen(request)»
				«ELSEIF countInput(request) == 2»
				Gen.map2 (fun i j -> «QCUtils.toUpperCaseFunction(request.name)» (i,j)) «compileUseRandomGen(request)»
				«ELSEIF countInput(request) == 3»
				Gen.map3 (fun i j x -> «QCUtils.toUpperCaseFunction(request.name)» (i,j,x)) «compileUseRandomGen(request)»
				«ENDIF»
		«ELSE»
		(Gen.return «QCUtils.toUpperCaseFunction(request.name)»)
		«ENDIF»
		'''
	}
	
	private def int countInput(Request request){
		request.body.value.countInputJsonUse
	}
	
	private def dispatch int countInputJsonUse(Json json){
		countInputJson(json)
	}
	private def dispatch int countInputJsonUse(VariableUse json){
		countInputJson(json.variable.variableValue)	
	}
	private def dispatch int countInputJson(JsonObject json){
		var result = 0
		for(Json jsonPair : json.jsonPairs) {
			result += countInputJson(jsonPair)		
		}
		return result
	}
	private def  dispatch int countInputJson(JsonList json){
		0
	}
	private def  dispatch int countInputJson(JsonPair json){
		json.value.countInputJson
	}
	private def  dispatch int countInputJson(IntValue json){
		0
	}
	private def  dispatch int countInputJson(StringValue json){
		0
	}
	private def  dispatch int countInputJson(IdValue json){
		0
	}
	private def  dispatch int countInputJson(RandStrValue json){
		1
	}
	private def  dispatch int countInputJson(RandIntValue json){
		1
	}
	private def  dispatch int countInputJson(IgnoreValue json){
		0
	}
	private def  dispatch int countInputJson(NestedJsonValue json){
		0
	}
	private def  dispatch int countInputJson(ListJsonValue json){
		0
	}
	
	private def CharSequence compileUseRandomGen(Request request){
		compileGenUseFromJsonUse(request.body.value)
	}
		
	private def  dispatch CharSequence compileGenUseFromJsonUse(Json json){
		compileGenUseFromJson(json)
	}
	private def  dispatch CharSequence compileGenUseFromJsonUse(VariableUse json){
		compileGenUseFromJson(json.variable.variableValue)	
	}
	private def  dispatch CharSequence compileGenUseFromJson(JsonObject json){
		var result = ""
		for(Json jsonPair : json.jsonPairs) {
			if(QCJsonUtils.containsRandomGenerationJson(jsonPair)){
				result += compileGenUseFromJson(jsonPair)
			}			
		}
		return result
	}
	private def  dispatch CharSequence compileGenUseFromJson(JsonList json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(JsonPair json){
		'''«json.value.compileGenUseFromJson»'''
	}
	private def  dispatch CharSequence compileGenUseFromJson(IntValue json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(StringValue json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(IdValue json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(RandStrValue json){
		'''str_gen '''
	}
	private def  dispatch CharSequence compileGenUseFromJson(RandIntValue json){
		'''int_gen '''
	}
	private def  dispatch CharSequence compileGenUseFromJson(IgnoreValue json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(NestedJsonValue json){
		''''''
	}
	private def  dispatch CharSequence compileGenUseFromJson(ListJsonValue json){
		''''''
	}
	
}