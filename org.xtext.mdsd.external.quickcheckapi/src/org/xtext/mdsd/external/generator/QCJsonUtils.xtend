package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Json
import org.xtext.mdsd.external.quickCheckApi.JsonObject
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.JsonPair
import org.xtext.mdsd.external.quickCheckApi.IntValue
import org.xtext.mdsd.external.quickCheckApi.StringValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.IdValue
import org.xtext.mdsd.external.quickCheckApi.VariableUse
import org.xtext.mdsd.external.quickCheckApi.IntType
import org.xtext.mdsd.external.quickCheckApi.StrType
import org.xtext.mdsd.external.quickCheckApi.IdType

class QCJsonUtils {
	
	def static dispatch boolean isIdInJsonUse(Json json){
		isIdInJson(json)
	}
	def static dispatch boolean isIdInJsonUse(VariableUse json){
		isIdInJson(json.variable.variableValue)
	}
	
	def static dispatch boolean isIdInJson(JsonObject json){
		for(Json jsonPair : json.jsonPairs) {
			if(isIdInJson(jsonPair)){
				return true
			}
		}
		false
	}
	def static dispatch boolean isIdInJson(JsonList json){
		for(Json jsonValue : json.jsonValues) {
			if(isIdInJson(jsonValue)){
				return true
			}
		}
		false
	}
	def static dispatch boolean isIdInJson(JsonPair json){
		isIdInJson(json.value)
	}
	def static dispatch boolean isIdInJson(IntValue json){
		false
	}
	def static dispatch boolean isIdInJson(StringValue json){
		false
	}
	def static dispatch boolean isIdInJson(IdValue json){
		true
	}
	def static dispatch boolean isIdInJson(NestedJsonValue json){
		isIdInJson(json.value)
	}
	def static dispatch boolean isIdInJson(ListJsonValue json){
		isIdInJson(json.value)
	}
	
	def static CharSequence trimJson(CharSequence json){
		json.toString.replace("{,","{")
					 .replace("[,","[")
					 .replace(",]","]")
					 .replace(",}","}")
					 .replace(",,",",")
	}
	
	def static dispatch CharSequence extractId(Json json){
		extractIdFunction(json)
	}
	def static dispatch CharSequence extractId(VariableUse json){
		extractIdFunction(json.variable.variableValue)
	}
	
	def static dispatch CharSequence extractIdFunction(JsonObject json){
		'''«FOR pair : json.jsonPairs»«pair.extractIdFunction»«ENDFOR»'''
	}
	def static dispatch CharSequence extractIdFunction(JsonList json){
		'''«FOR value : json.jsonValues»«value.extractIdFunction»«ENDFOR»'''
	}
	def static dispatch CharSequence extractIdFunction(JsonPair json){
		if(isIdInJson(json)){
			'''|> member "«json.key»" «json.value.extractIdFunction» '''
		} else {
		''''''
		}
	}
	def static dispatch CharSequence extractIdFunction(IntValue json){
		''''''
	}
	def static dispatch CharSequence extractIdFunction(IdValue json){
		'''«extractIdConversion(json.value.idType)»'''
	}
	def static dispatch CharSequence extractIdFunction(NestedJsonValue json){
		''''''
	}
	def static dispatch CharSequence extractIdFunction(ListJsonValue json){
		''''''
	}
		
	def static dispatch CharSequence extractIdConversion(IntType type){
		'''
		|> to_int in
		let id = string_of_int id
		'''
	}
	def static dispatch CharSequence extractIdConversion(StrType type){
		'''|> to_string'''
	}
	
}