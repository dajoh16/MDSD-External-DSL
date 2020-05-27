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
import org.xtext.mdsd.external.quickCheckApi.RandIntValue
import org.xtext.mdsd.external.quickCheckApi.RandStrValue
import org.xtext.mdsd.external.quickCheckApi.IgnoreValue

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
	def static dispatch boolean isIdInJson(RandStrValue json){
		false
	}
	def static dispatch boolean isIdInJson(RandIntValue json){
		false
	}
	def static dispatch boolean isIdInJson(IgnoreValue json){
		false
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
	def static dispatch CharSequence extractIdFunction(RandStrValue json){
		''''''
	}
	def static dispatch CharSequence extractIdFunction(RandIntValue json){
		''''''
	}
	def static dispatch CharSequence extractIdFunction(IgnoreValue json){
		''''''
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
	
	def static dispatch CharSequence extractIdJsonFromJsonUse(Json json){
		extractIdJsonFromJson(json)
	}
	def static dispatch CharSequence extractIdJsonFromJsonUse(VariableUse json){
		extractIdJsonFromJson(json.variable.variableValue)
	}
	
	def static dispatch CharSequence extractIdJsonFromJson(JsonObject json){
		for(Json jsonPair : json.jsonPairs) {
			if(isIdInJson(jsonPair)){
				return extractIdJsonFromJson(jsonPair)
			}
		}
	}
	def static dispatch CharSequence extractIdJsonFromJson(JsonList json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(JsonPair json){
		'''"{\"«json.key»\": «extractIdJsonFromJson(json.value)» }"'''
	}
	def static dispatch CharSequence extractIdJsonFromJson(IntValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(StringValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(IdValue json){
		'''" ^ id ^ "'''
	}
	def static dispatch CharSequence extractIdJsonFromJson(RandStrValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(RandIntValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(IgnoreValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(NestedJsonValue json){
		''''''
	}
	def static dispatch CharSequence extractIdJsonFromJson(ListJsonValue json){
		''''''
	}
	
	
	def static dispatch boolean containsRandomGenerationJsonUse(Json json){
		containsRandomGenerationJson(json)
	}
	def static dispatch boolean containsRandomGenerationJsonUse(VariableUse json){
		containsRandomGenerationJson(json.variable.variableValue)	
	}
	
	def static dispatch boolean containsRandomGenerationJson(JsonObject json){
		for(Json jsonPair : json.jsonPairs) {
			if(containsRandomGenerationJson(jsonPair)){
				return true
			}
		}
		false
	}
	def static dispatch boolean containsRandomGenerationJson(JsonList json){
		for(Json jsonValue : json.jsonValues) {
			if(containsRandomGenerationJson(jsonValue)){
				return true
			}
		}
		false
	}
	def static dispatch boolean containsRandomGenerationJson(JsonPair json){
		containsRandomGenerationJson(json.value)
	}
	def static dispatch boolean containsRandomGenerationJson(IntValue json){
		false
	}
	def static dispatch boolean containsRandomGenerationJson(StringValue json){
		false
	}
	def static dispatch boolean containsRandomGenerationJson(IdValue json){
		false
	}
	def static dispatch boolean containsRandomGenerationJson(RandIntValue json){
		true
	}
	def static dispatch boolean containsRandomGenerationJson(RandStrValue json){
		true
	}
	def static dispatch boolean containsRandomGenerationJson(IgnoreValue json){
		false
	}
	def static dispatch boolean containsRandomGenerationJson(NestedJsonValue json){
		containsRandomGenerationJson(json.value)
	}
	def static dispatch boolean containsRandomGenerationJson(ListJsonValue json){
		containsRandomGenerationJson(json.value)
	}
	
	def static dispatch boolean isIgnoreInJsonUse(Json json){
		isIgnoreInJson(json)
	}
	def static dispatch boolean isIgnoreInJsonUse(VariableUse json){
		isIgnoreInJson(json.variable.variableValue)
	}
	
	def static dispatch boolean isIgnoreInJson(JsonObject json){
		for(Json jsonPair : json.jsonPairs) {
			if(isIgnoreInJson(jsonPair)){
				return true
			}
		}
		false
	}
	def static dispatch boolean isIgnoreInJson(JsonList json){
		for(Json jsonValue : json.jsonValues) {
			if(isIgnoreInJson(jsonValue)){
				return true
			}
		}
		false
	}
	def static dispatch boolean isIgnoreInJson(JsonPair json){
		isIgnoreInJson(json.value)
	}
	def static dispatch boolean isIgnoreInJson(IntValue json){
		false
	}
	def static dispatch boolean isIgnoreInJson(StringValue json){
		false
	}
	def static dispatch boolean isIgnoreInJson(IdValue json){
		false
	}
	def static dispatch boolean isIgnoreInJson(RandStrValue json){
		false
	}
	def static dispatch boolean isIgnoreInJson(RandIntValue json){
		false
	}
	def static dispatch boolean isIgnoreInJson(IgnoreValue json){
		true
	}
	def static dispatch boolean isIgnoreInJson(NestedJsonValue json){
		isIgnoreInJson(json.value)
	}
	def static dispatch boolean isIgnoreInJson(ListJsonValue json){
		isIgnoreInJson(json.value)
	}
	
	
	
	
}