/*
 * generated by Xtext 2.20.0
 */
package org.xtext.mdsd.external.validation

import org.xtext.mdsd.external.quickCheckApi.Builder
import org.eclipse.xtext.validation.Check
import org.xtext.mdsd.external.quickCheckApi.QuickCheckApiPackage
import org.xtext.mdsd.external.quickCheckApi.Test

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.xtext.mdsd.external.quickCheckApi.CreateAction
import org.xtext.mdsd.external.quickCheckApi.VariableDef
import org.xtext.mdsd.external.generator.QCJsonUtils
import org.xtext.mdsd.external.generator.QCUtils
import org.xtext.mdsd.external.quickCheckApi.JsonList
import org.xtext.mdsd.external.quickCheckApi.ListJsonValue
import org.xtext.mdsd.external.quickCheckApi.NestedJsonValue

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class QuickCheckApiValidator extends AbstractQuickCheckApiValidator {
	
	@Check
	def checkForDuplicateTestNames(Builder builder){
		var duplicates = builder.tests.groupBy[it.name].filter[p1, p2| p2.size > 1]
		 if (duplicates.size > 0){
		 	duplicates.forEach[p1, p2|p2.forEach[error("Duplicate Test Name",it, QuickCheckApiPackage.Literals.TEST__NAME)]]
		 }
	}
	
	@Check
	def checkForDuplicateRequestNames(Test test){
		var duplicates = test.requests.groupBy[it.name].filter[p1, p2| p2.size > 1]
		 if (duplicates.size > 0){
		 	duplicates.forEach[p1, p2|p2.forEach[error("Duplicate Request Name",it, QuickCheckApiPackage.Literals.REQUEST__NAME)]]
		 }
	}
	
	@Check
	def checkForDuplicateVariableNames(Test test){
		var duplicates = test.variableDefs.groupBy[it.name].filter[p1, p2| p2.size > 1]
		 if (duplicates.size > 0){
		 	duplicates.forEach[p1, p2|p2.forEach[error("Duplicate Variable Name",it, QuickCheckApiPackage.Literals.VARIABLE_DEF__NAME)]]
		 }
	}
	
	@Check
	def checkForMoreThanOneCreate(Test test){
		val createActions = test.getAllContentsOfType(CreateAction)
		if(createActions.size > 1){
			createActions.forEach[error("A test can only contain one Create statement - \n If there are multiple entities in the test it should be moved to a separate test",it,QuickCheckApiPackage.eINSTANCE.createAction_Value)]
		}
	}
	
	@Check
	def checkOnlyThreeInputsForCmd(Test test){
		val variableDefs = test.getAllContentsOfType(VariableDef)
		for(varDef : variableDefs){
			if(QCUtils.countInputJson(varDef.variableValue) > 3){
				error("A variable can only have 3 random + id due to a limitation of OCaml code", varDef,QuickCheckApiPackage.eINSTANCE.variableDef_VariableValue)
			}
		}
	}
	
	@Check
	def checkJsonListsNotSupported(Test test){
		val jsonLists = test.getAllContentsOfType(JsonList)
		jsonLists.forEach[error("Json Lists are not supported at this time",it,QuickCheckApiPackage.eINSTANCE.jsonList_JsonValues)]
	}
	
	@Check
	def checkNestedJsonListNotSupported(Test test){
		val jsonLists = test.getAllContentsOfType(ListJsonValue)
		jsonLists.forEach[error("Json Lists are not supported at this time",it,QuickCheckApiPackage.eINSTANCE.listJsonValue_Value)]
	}
	
	@Check
	def checkNestedJsonObjectNotSupported(Test test){
		val jsonLists = test.getAllContentsOfType(NestedJsonValue)
		jsonLists.forEach[error("Nested Json Objects are not supported at this time",it,QuickCheckApiPackage.eINSTANCE.nestedJsonValue_Value)]
	}
	
	@Check
	def checkIdIsFirst(Test test){
		val variableDefs = test.getAllContentsOfType(VariableDef)
		for(varDef : variableDefs){
			if(QCJsonUtils.isIdInJson(varDef.variableValue) && !QCValidatorUtils.isIdFirstInJson(varDef.variableValue)){
				error("The Id must be first in the Json", varDef,QuickCheckApiPackage.eINSTANCE.variableDef_VariableValue)
			}
		}
	}
}
