package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.POST
import org.xtext.mdsd.external.quickCheckApi.Request

class QCArbCmd {
	
	def initArb_cmd(Test test ) {
		
		'''
		let arb_cmd state = 
		  let int_gen = Gen.oneof [Gen.small_int] in
		  if state = [] then
		    QCheck.make ~print:show_cmd
		    (Gen.oneof [
		    �FOR postRequest: QCUtils.filterbyMethod(test.requests,POST) SEPARATOR ";"�
		    (Gen.return �postRequest.name�)
		    �ENDFOR�
		    ])
		    
		  else
		    QCheck.make ~print:show_cmd
		      (Gen.oneof [ Gen.return Create;
		                  Gen.map (fun i -> Delete i) int_gen;
		                  Gen.map (fun i -> Get i) int_gen])
		                
		'''
	}
	
	
}