"
I'm a ""debug it"" command. 
I will debug the selection (or line) of the playground.
"
Class {
	#name : 'SpCodeDebugItCommand',
	#superclass : 'SpCodeSelectionCommand',
	#category : 'Spec2-Code-Commands-Base',
	#package : 'Spec2-Code-Commands',
	#tag : 'Base'
}

{ #category : 'accessing' }
SpCodeDebugItCommand class >> defaultDescription [

	^ 'Debug selection.'
]

{ #category : 'default' }
SpCodeDebugItCommand class >> defaultIconName [

	^ #smallDebug
]

{ #category : 'default' }
SpCodeDebugItCommand class >> defaultName [ 

	^ 'Debug it'
]

{ #category : 'default' }
SpCodeDebugItCommand class >> defaultShortcutKey [

	^ $d shift actionModifier
]

{ #category : 'private' }
SpCodeDebugItCommand >> debug: aStream [

	| method doItReceiver doItContext |
	doItReceiver := self context doItReceiver.
	doItContext := self context doItContext.

	method := self compile: aStream for: doItReceiver in: doItContext.
	method ifNil: [ ^ self ].
	self debug: method receiver: doItReceiver in: doItContext
]

{ #category : 'private' }
SpCodeDebugItCommand >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| process suspendedContext debugRequest |

	process := [ 
		aCompiledMethod
			valueWithReceiver: anObject
			arguments: (aCompiledMethod numArgs = 0 
				ifTrue: [ #() ] 
				ifFalse: [ { evalContext } ] ) ]
			newProcess.
	suspendedContext := process suspendedContext.

	debugRequest := (OupsDebugRequest newForContext: suspendedContext)
		process: process;
		compiledMethod: aCompiledMethod;
		label: 'debug it';
		yourself.
	debugRequest debugSession application: context application.
	debugRequest submit
]

{ #category : 'execution' }
SpCodeDebugItCommand >> execute [
	| selection |

	selection := self selectedTextOrLine.
	selection ifEmpty: [ ^ '' ].
	
	self debug: selection readStream
]
