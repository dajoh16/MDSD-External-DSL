package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test

class QCJsonIgnoreExtractor {
	
	def CharSequence initIgnoreExtractor(Test test){
		'''
		«FOR varDef : test.variableDefs»
		
		«ENDFOR»
		'''
	}
}