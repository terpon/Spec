Class {
	#name : 'SpMorphicScrollableAdapterTest',
	#superclass : 'TestCase',
	#instVars : [
		'scrollable',
		'presenter'
	],
	#category : 'Spec2-Adapters-Morphic-Tests',
	#package : 'Spec2-Adapters-Morphic-Tests'
}

{ #category : 'running' }
SpMorphicScrollableAdapterTest >> configureBasicContainer: aNumber [

	| boxLayout widgets |
	boxLayout := SpBoxLayout newVertical.
	widgets := (1 to: aNumber) collect: [ : i | 
		boxLayout add: (SpButtonPresenter new label: i asString; yourself) ].

	presenter := SpPresenter new
		layout: (scrollable := SpScrollableLayout new
			child:(SpPresenter new
				layout: boxLayout;
				yourself);
			yourself);
		yourself.

]

{ #category : 'running' }
SpMorphicScrollableAdapterTest >> tearDown [

	presenter delete.
	super tearDown.
]

{ #category : 'tests' }
SpMorphicScrollableAdapterTest >> testVScrollToAfterOpen100SubPresenters [
	
	| adapterWidget |
	
	self configureBasicContainer: 100.
	presenter open.
	scrollable withAdapterDo: [ : a | a widget height: 270 ].

	self assert: presenter isDisplayed.
	self assert: presenter isVisible.

	scrollable scrollTo: 0.1 @ 2.
	adapterWidget := scrollable adapter widget.
	self assert: adapterWidget vScrollbarValue closeTo: 0.74074074074074.
	
	scrollable scrollTo: 0.5 @ 2.
	adapterWidget := scrollable adapter widget.
	self assert: adapterWidget vScrollbarValue closeTo: 0.74074074074074
]

{ #category : 'tests' }
SpMorphicScrollableAdapterTest >> testVScrollToAfterOpen500SubPresenters [
	
	| adapterWidget |
	
	self configureBasicContainer: 500.
	presenter open.
	scrollable withAdapterDo: [ : a | a widget height: 270 ].
	scrollable scrollTo: 0.1 @ 2.
	adapterWidget := scrollable adapter widget.
	self assert: adapterWidget vScrollbarValue closeTo: 0.74074074074074
]

{ #category : 'tests' }
SpMorphicScrollableAdapterTest >> testVScrollToBeforeOpen100SubPresenters [
	
	| adapterWidget |
	
	self configureBasicContainer: 100.
	scrollable scrollTo: 0.1 @ 2.
	presenter open.
	adapterWidget := scrollable adapter widget.
	self assert: adapterWidget vScrollbarValue closeTo: 0.0
]