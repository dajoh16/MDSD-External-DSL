package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
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
import org.xtext.mdsd.external.quickCheckApi.StrType
import org.xtext.mdsd.external.quickCheckApi.IntType

class QCJsonIgnoreExtractor {
	
	var lastJsonKey = "";
	
	def CharSequence initIgnoreExtractor(Test test){
		'''
		«FOR varDef : test.variableDefs»
		«IF QCJsonUtils.isIgnoreInJsonUse(varDef.variableValue)»
			let ignore«varDef.name» content = 
				«varDef.variableValue.extractNonIgnoredJson»
					Yojson.Basic.from_string («QCJsonUtils.trimJson(varDef.variableValue.compileNonIgnoredJson)»)
		«ENDIF»
		«ENDFOR»
		'''
	}
	
	def dispatch CharSequence extractNonIgnoredJson(JsonObject json){
		'''
		«FOR jsonPair : json.jsonPairs»
			«extractNonIgnoredJson(jsonPair)»
		«ENDFOR»
		'''
	}
	def dispatch CharSequence extractNonIgnoredJson(JsonList json){
		''''''
	}
	def dispatch CharSequence extractNonIgnoredJson(JsonPair json){
		'''
		«IF !QCJsonUtils.isIgnoreInJson(json.value)»
			let «json.key.toFirstLower» = content |> member "«json.key»" |> «json.value.extractNonIgnoredJson» in
		«ENDIF»
		'''
	}
	def dispatch CharSequence extractNonIgnoredJson(IntValue json){
		'''to_int'''
	}
	def dispatch CharSequence extractNonIgnoredJson(StringValue json){
		'''to_string'''
	}
	def dispatch CharSequence extractNonIgnoredJson(IdValue json){
		'''«json.value.idType.extractNonIgnoredIdType»'''
	}
	def dispatch CharSequence extractNonIgnoredIdType(StrType str){
		'''to_string'''
	}
	def dispatch CharSequence extractNonIgnoredIdType(IntType integer){
		'''to_int'''
	}
	def dispatch CharSequence extractNonIgnoredJson(RandStrValue json){
		'''to_string'''
	}
	def dispatch CharSequence extractNonIgnoredJson(RandIntValue json){
		'''to_int'''
	}
	def dispatch CharSequence extractNonIgnoredJson(IgnoreValue json){
		''''''
	}
	def dispatch CharSequence extractNonIgnoredJson(NestedJsonValue json){
		''''''
	}
	def dispatch CharSequence extractNonIgnoredJson(ListJsonValue json){
		''''''
	}
	
	def dispatch CharSequence compileNonIgnoredJson(JsonObject json){
		'''"{«FOR jsonPair : json.jsonPairs SEPARATOR ","»«compileNonIgnoredJson(jsonPair)»«ENDFOR»}"'''
	}
	def dispatch CharSequence compileNonIgnoredJson(JsonList json){
		''''''
	}
	def dispatch CharSequence compileNonIgnoredJson(JsonPair json){
		lastJsonKey = json.key.toFirstLower
		'''«IF !QCJsonUtils.isIgnoreInJson(json.value)»\"«json.key»\": «json.value.compileNonIgnoredJson»«ENDIF»'''
	}
	def dispatch CharSequence compileNonIgnoredJson(IntValue json){
		'''" ^ «lastJsonKey» ^ "'''
	}
	def dispatch CharSequence compileNonIgnoredJson(StringValue json){
		'''\"" ^ «lastJsonKey» ^ "\"'''
	}
	def dispatch CharSequence compileNonIgnoredJson(IdValue json){
		'''«compileNonIgnoredIdType(json.value.idType)»'''
	}
	def dispatch CharSequence compileNonIgnoredIdType(StrType str){
		'''\"" ^ «lastJsonKey» ^ "\"'''
	}
	def dispatch CharSequence compileNonIgnoredIdType(IntType integer){
		'''" ^ «lastJsonKey» ^ "'''
	}
	def dispatch CharSequence compileNonIgnoredJson(RandStrValue json){
		'''\"" ^ «lastJsonKey» ^ "\"'''
	}
	def dispatch CharSequence compileNonIgnoredJson(RandIntValue json){
		'''" ^ «lastJsonKey» ^ "'''
	}
	def dispatch CharSequence compileNonIgnoredJson(IgnoreValue json){
		''''''
	}
	def dispatch CharSequence compileNonIgnoredJson(NestedJsonValue json){
		''''''
	}
	def dispatch CharSequence compileNonIgnoredJson(ListJsonValue json){
		''''''
	}
}