package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Host
import org.xtext.mdsd.external.quickCheckApi.Port
import org.xtext.mdsd.external.quickCheckApi.URI
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.IdValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.VariableUse
import org.xtext.mdsd.external.quickCheckApi.RandStrValue
import org.xtext.mdsd.external.quickCheckApi.RandIntValue
import org.xtext.mdsd.external.quickCheckApi.IgnoreValue

class QCCmd {
	

	
	def CharSequence initCmd(Test test){
		'''
		type cmd =
			 «FOR request : test.requests »
			 | «QCUtils.toUpperCaseFunction(request.name)»«request.indexSnippet»
			 «ENDFOR»
			 [@@deriving show { with_path = false }]
		
		«FOR request : test.requests »
		let «QCUtils.firstCharLowerCase(request.name)»URL="«request.url.protocol»://«request.url.domain.host.compile()»«request.url.domain.port.compile()»/«request.url.domain.uri.compile()»"
		«ENDFOR»
		'''
	}
			
	 private def CharSequence compile(Host host) {
		if(host.hostParts.empty) {
			'''«FOR ip : host.ips SEPARATOR "."»«ip.toString»«ENDFOR»'''
		} else {
			'''«FOR hostPart : host.hostParts SEPARATOR "."»«hostPart.toString»«ENDFOR»'''
		}	
	}
	
	 private def CharSequence compile(Port port) {
		'''
		«IF !(port === null)  »:« port.value.toString »«ENDIF»'''
	}
	
	 private def CharSequence compile(URI uri) {
		'''«IF uri !== null»«uri.name»/«FOR part : uri.path SEPARATOR "/"»«part.part»«ENDFOR»«ENDIF»'''
	}
	
	
	
	private def CharSequence indexSnippet(Request request){
		if (QCUtils.requireIndex(request)) {
			''' of int «IF request.shouldContainRandCmdTypes»* «request.compileRandCmdTypes»«ENDIF»'''
		} else {
			'''«IF request.shouldContainRandCmdTypes» of «request.compileRandCmdTypes»«ENDIF»'''
		}
	}
	
	private def boolean shouldContainRandCmdTypes(Request request){
		if(request.body !== null && request.body.value !== null){
			QCJsonUtils.containsRandomGenerationJsonUse(request.body.value)
		} else {
			false
		}
	}
	
	private def CharSequence compileRandCmdTypes(Request request){
		compileCmdRandomGenerationJsonUse(request.body.value)
	}
	
	private def  dispatch CharSequence compileCmdRandomGenerationJsonUse(Json json){
		compileCmdRandomGenerationJson(json)
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJsonUse(VariableUse json){
		compileCmdRandomGenerationJson(json.variable.variableValue)	
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(JsonObject json){
		var result = ""
		var first = true
		for(Json jsonPair : json.jsonPairs) {
			if(QCJsonUtils.containsRandomGenerationJson(jsonPair)){
				if(first){
					result += compileCmdRandomGenerationJson(jsonPair)
					first = false
				} else {
					result += " * " + compileCmdRandomGenerationJson(jsonPair)
				}
			}			
		}
		return result
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(JsonList json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(JsonPair json){
		'''«json.value.compileCmdRandomGenerationJson»'''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(IntValue json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(StringValue json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(IdValue json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(RandStrValue json){
		'''string'''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(RandIntValue json){
		'''int'''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(IgnoreValue json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(NestedJsonValue json){
		''''''
	}
	private def  dispatch CharSequence compileCmdRandomGenerationJson(ListJsonValue json){
		''''''
	}
	
}