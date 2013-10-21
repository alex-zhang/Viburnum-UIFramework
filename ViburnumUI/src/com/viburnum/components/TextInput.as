package com.viburnum.components
{
    import com.viburnum.components.baseClasses.TextBase;
    import com.viburnum.interfaces.IUITextField;
    
    import flash.text.TextFieldType;

    public class TextInput extends TextBase implements IFocusManagerComponent
    {
		private var _displayAsPassword:Boolean = false;
		private var _displayAsPasswordChangedFlag:Boolean = false;
		
		private var _editable:Boolean = true;
		private var _editableChangedFlag:Boolean = false;
		
        public function TextInput()
        {
            super();

			selectable = true;
        }
		
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		[Inspectable(type="Boolean", defaultValue="false")]
		public function set displayAsPassword(value:Boolean):void
		{
			if(_displayAsPassword != value)
			{
				_displayAsPassword = value;
				
				_displayAsPasswordChangedFlag = true;

				invalidateProperties();
			}
		}
		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		[Inspectable(type="Boolean", defaultValue="true")]
		public function set editable(value:Boolean):void
		{
			if(_editable != value)
			{
				_editable = value;
				_editableChangedFlag = true;
				
				invalidateProperties();
			}
		}
		
		override protected function createTextField():IUITextField
		{
			var t:IUITextField = super.createTextField();
			t.type = TextFieldType.INPUT;
			
			return t;
		}
		
		override protected function updateTextFiledTypeSetting():void
		{
			super.updateTextFiledTypeSetting();
			
			holdTextField.type = (enabled && editable) ? 
				TextFieldType.INPUT : 
				TextFieldType.DYNAMIC;
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_displayAsPasswordChangedFlag)
			{
				_displayAsPasswordChangedFlag = false;
				
				holdTextField.displayAsPassword = _displayAsPassword;
			}
			
			if(_editableChangedFlag)
			{
				_editableChangedFlag = false;
				
				updateTextFiledTypeSetting();
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			var measuredMW:Number = Math.max(measuredWidth, 80);
			
			setMeasuredSize(measuredMW, measuredHeight);
		}
    }
}