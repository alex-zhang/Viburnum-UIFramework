package com.viburnum.components.baseClasses
{
	import com.viburnum.components.TextInput;

	public class NumericStepperBase extends RangeBase
	{
		protected var textInput:TextInput;
		private var _textFormatFunction:Function;
		
		public function NumericStepperBase()
		{
			super();
			
			maximum = 10;
		}
		
		public function get textFormatFunction():Function
		{
			return _textFormatFunction;
		}
		
		public function set textFormatFunction(value:Function):void
		{
			_textFormatFunction = value;
		}
		
		override protected function setValue(value:Number):void
		{
			super.setValue(value);
			
			textInput.text = formatValueToString(value);
		}
		
		private function formatValueToString(value:Number):String
		{
			var formattedValue:String;
			
			if(_textFormatFunction != null)
			{
				formattedValue = _textFormatFunction(value);
			}
			else
			{
				formattedValue = int(value).toString();				
			}
			
			return formattedValue;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			textInput = new TextInput();
			textInput.restrict = "0-9\\-\\.\\,";
			addChild(textInput);
		}
	}
}