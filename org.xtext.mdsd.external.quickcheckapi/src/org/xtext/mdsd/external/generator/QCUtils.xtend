package org.xtext.mdsd.external.generator

import org.eclipse.emf.common.util.EList
import org.xtext.mdsd.external.quickCheckApi.Method
import java.util.List
import java.util.ArrayList

import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.VariableUse
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.IdValue
import org.xtext.mdsd.external.quickCheckApi.RandStrValue
import org.xtext.mdsd.external.quickCheckApi.RandIntValue
import org.xtext.mdsd.external.quickCheckApi.IgnoreValue

class QCUtils {
	static var jsonKeyForCompile = ""
		
	def static List<Request> filterbyMethod(EList<Request> requests, Class<? extends Method> method){
		val filtered = new ArrayList
		for (request : requests) {
			if (method.isAssignableFrom(request.method.class)) {
				filtered.add(request)
			}
		}
		filtered
	}
	
	def static toUpperCaseFunction(String s) {
		 s.substring(0,1).toUpperCase + s.substring(1)
	}
	
	def static firstCharLowerCase(String s) {
		 s.substring(0,1).toLowerCase + s.substring(1)
	}
	
	
	
	def static boolean requireIndex(Request request){
		// If anything else than a CreateAction then True
		if(request.url.domain.requestID === null)
			false
		else if (CreateAction.isAssignableFrom(request.action.class))
			false
		else
			true
	}
	
	def static List<Request> filterRequireIndex(EList<Request> requests){
		requests.filterIndex(true)
	}
	
	def static List<Request> filterRequireNoIndex(EList<Request> requests){
		requests.filterIndex(false)
	}
	
	def static List<Request> filterIndex(EList<Request> requests, boolean require){
		val filtered = new ArrayList
		for (request : requests) {
			if (request.requireIndex == require) {
				filtered.add(request)
			}
		}
		filtered
	}
	
	def static dispatch CharSequence compileJson(JsonObject json){
		'''{«FOR pair : json.jsonPairs SEPARATOR ","»«pair.compileJson»«ENDFOR»}'''
	}
	def static dispatch CharSequence compileJson(JsonList json){
		'''[«FOR value : json.jsonValues SEPARATOR ","»«value.compileJson»«ENDFOR»]'''
	}
	def static dispatch CharSequence compileJson(JsonPair json){
		if(QCJsonUtils.isIdInJson(json) || QCJsonUtils.isIgnoreInJson(json)){
			''''''
		} else {
			jsonKeyForCompile = json.key
			'''\"«json.key»\":«json.value.compileJson»'''
		}
	}
	def static dispatch CharSequence compileJson(IntValue json){
		'''«json.value»'''
	}
	def static dispatch CharSequence compileJson(StringValue json){
		'''\"«json.value»\"'''
	}
	def static dispatch CharSequence compileJson(RandIntValue json){
		'''" ^ «jsonKeyForCompile» ^ "'''
	}
	def static dispatch CharSequence compileJson(RandStrValue json){
		'''" ^ «jsonKeyForCompile» ^ "'''
	}
	def static dispatch CharSequence compileJson(IgnoreValue json){
		''''''
	}
	def static dispatch CharSequence compileJson(NestedJsonValue json){
		'''«json.value.compileJson»'''
	}
	def static dispatch CharSequence compileJson(ListJsonValue json){
		'''«json.value.compileJson»'''
	}
	def static dispatch CharSequence compileJson(IdValue json){
		''''''
	}
	
	def static dispatch CharSequence compileJsonUse(VariableUse json){
		QCJsonUtils.trimJson(QCUtils.compileJson(json.variable.variableValue))
		
	}
	def static dispatch CharSequence compileJsonUse(Json json){
		QCJsonUtils.trimJson(QCUtils.compileJson(json))
	}	
	
	def static CharSequence compilePatternMatchingRequest(Request request){
		if(request.body !== null){
			'''«QCUtils.toUpperCaseFunction(request.name)»«IF request.body.value.countInputJsonUse > 1»(«ENDIF»«request.body.value.compilePatternMatchingJsonUse»«IF request.body.value.countInputJsonUse > 1»)«ENDIF» -> '''
		} else if(request.requireIndex){
			'''«QCUtils.toUpperCaseFunction(request.name)» ix -> '''
		} else if(!request.requireIndex){
			'''«QCUtils.toUpperCaseFunction(request.name)» -> '''
		}
	}
	
	def static dispatch CharSequence compilePatternMatchingJsonUse(Json json){
		compilePatternMatching(json)
	}
	def static dispatch CharSequence compilePatternMatchingJsonUse(VariableUse json){
		compilePatternMatching(json.variable.variableValue)
	}
	
	def static dispatch CharSequence compilePatternMatching(JsonObject json){
		var first = true
		var result = ""
		for(Json jsonPair : json.jsonPairs) {
			if(first){
				result += compilePatternMatching(jsonPair)
				first = false;
			} else {
				result += "," + compilePatternMatching(jsonPair)
			}
		}
		result
	}
	def static dispatch CharSequence compilePatternMatching(JsonList json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(JsonPair json){
		'''«IF QCJsonUtils.isIdInJson(json.value)»ix«ELSEIF QCJsonUtils.containsRandomGenerationJson(json.value)»«json.key»«ENDIF»'''
	}
	def static dispatch CharSequence compilePatternMatching(IntValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(StringValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(IdValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(RandStrValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(RandIntValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(IgnoreValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(NestedJsonValue json){
		''''''
	}
	def static dispatch CharSequence compilePatternMatching(ListJsonValue json){
		''''''
	}
	
	
	
	def static dispatch int countInputJsonUse(Json json){
		countInputJson(json)
	}
	def static dispatch int countInputJsonUse(VariableUse json){
		countInputJson(json.variable.variableValue)	
	}
	def static dispatch int countInputJson(JsonObject json){
		var result = 0
		for(Json jsonPair : json.jsonPairs) {
			result += countInputJson(jsonPair)		
		}
		return result
	}
	def static dispatch int countInputJson(JsonList json){
		0
	}
	def static dispatch int countInputJson(JsonPair json){
		json.value.countInputJson
	}
	def static dispatch int countInputJson(IntValue json){
		0
	}
	def static dispatch int countInputJson(StringValue json){
		0
	}
	def static dispatch int countInputJson(IdValue json){
		1
	}
	def static dispatch int countInputJson(RandStrValue json){
		1
	}
	def static dispatch int countInputJson(RandIntValue json){
		1
	}
	def static dispatch int countInputJson(IgnoreValue json){
		0
	}
	def static dispatch int countInputJson(NestedJsonValue json){
		0
	}
	def static dispatch int countInputJson(ListJsonValue json){
		0
	}
	
}