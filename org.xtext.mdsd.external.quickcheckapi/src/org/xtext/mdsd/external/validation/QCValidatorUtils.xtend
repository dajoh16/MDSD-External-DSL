package org.xtext.mdsd.external.validation

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
import org.xtext.mdsd.external.generator.QCJsonUtils

class QCValidatorUtils {
	
	def static dispatch boolean isIdFirstInJson(JsonObject json){
		if(QCJsonUtils.isIdInJson(json)){
			for(pair : json.jsonPairs){
				return isIdFirstInJson(pair)
			}
		}
		false
	}
	def static dispatch boolean isIdFirstInJson(JsonList json){
		false
	}
	def static dispatch boolean isIdFirstInJson(JsonPair json){
		json.value.isIdFirstInJson
	}
	def static dispatch boolean isIdFirstInJson(IntValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(StringValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(IdValue json){
		true
	}
	def static dispatch boolean isIdFirstInJson(RandStrValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(RandIntValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(IgnoreValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(NestedJsonValue json){
		false
	}
	def static dispatch boolean isIdFirstInJson(ListJsonValue json){
		false
	}
}