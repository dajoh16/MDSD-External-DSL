package org.xtext.mdsd.external.generator

import org.xtext.mdsd.external.quickCheckApi.Test
import org.xtext.mdsd.external.quickCheckApi.Request
import org.xtext.mdsd.external.quickCheckApi.Action
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.DeleteAction
import org.xtext.mdsd.external.quickCheckApi.UpdateAction
import org.xtext.mdsd.external.quickCheckApi.NoAction

class QCNextState {
	
	def initNext_State(Test test ) {
		'''
		let next_state cmd state = match cmd with
			�FOR request : test.requests�
			| �QCUtils.toUpperCaseFunction(request.name)� �request.compileNextState�
			�ENDFOR�
		'''
	}
	
	def CharSequence compileNextState(Request request){
		request.action.compile
	}
	
	def CharSequence compile(Action action){
		
		if (action instanceof CreateAction) {
			''' -> state@["�QCUtils.compileJsonUse(action.value)�"]'''	
		} else if (action instanceof DeleteAction){
			'''
			ix -> let pos = getPos ix state in
			      (* Returns a list of all items except that which is 'item' found above *)
			      let l = remove_item pos state in
			      l
	        '''
		} else if (action instanceof UpdateAction){
			'''
			ix -> let newelem = "�QCUtils.compileJsonUse(action.value)�" in
			      let pos = getPos ix state in
			      replaceElem pos state newelem
			'''	
		} else if (action instanceof NoAction){
			''' ix -> state'''
		} else {
			''''''
		}
	}
}
	
	