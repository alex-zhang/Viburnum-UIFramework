package com.viburnum.components
{
	import com.viburnum.components.baseClasses.DropDownListBase;
	import com.viburnum.events.DateChooserEvent;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	include "../style/styleMetadata/GapStyle.as";

	[Style(name="dateFieldIcon", type="Class")]
	
    public class DateField extends DropDownListBase
    {
		public static function getStyleDefinition():Object 
		{
			return [
				//GapStyle
				{name:"gap", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				
				{name:"dateFieldIcon", type:"Class"},
			]
		}
		
		protected var textInput:TextInput;

		private var _selectedDate:Date;
		private var _selectedDateChangedFlag:Boolean = false;
		
		private var _textFormatFunction:Function;
		
        public function DateField()
        {
            super();

			selectedDate = new Date();
        }
		
		public function get textFormatFunction():Function
		{
			return _textFormatFunction;
		}
		
		public function set textFormatFunction(value:Function):void
		{
			_textFormatFunction = value;
		}
		
		public function set selectedDate(value:Date):void
		{
			if(value == null) return;
			
			if(_selectedDate == null ||
				_selectedDate.fullYear != value.fullYear || 
				_selectedDate.month || value.month || 
				_selectedDate.date || value.date)
			{
				_selectedDate = value;
				_selectedDateChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "dateFieldIcon")
			{
				openButton.setStyle("backgroundSkin", getStyle(styleProp));
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			textInput = new TextInput();
			textInput.editable = false;
			addChild(textInput);

			openButton = new SimpleButton();
			openButton.addEventListener(MouseEvent.MOUSE_DOWN, openButtonMouseDownHandler);
			addChild(openButton);
		}
		
		override protected function createDropDownTarget():DisplayObject
		{
			var dateChooser:DateChooser = new DateChooser();
			return dateChooser;
		}
		
		override protected function addPopupDropDown(dropDown:DisplayObject):void
		{
			DateChooser(dropDown).selectedDate = _selectedDate;
			dropDown.addEventListener(DateChooserEvent.DATE_SELECTED, dateSelectedHandler);
			
			if(application != null)
			{
				var gap:Number = getStyle("gap") || 0;
				var w:Number = textInput.width + gap;
				
				var p:Point = localToGlobal(new Point(w, 0));
				p = application.globalToLocal(p);
				
				LayoutUtil.setDisplayObjectPosition(dropDown, p.x, p.y);
			}
			
			super.addPopupDropDown(dropDown);
		}
		
		override protected function removePopupDropDown(dropDown:DisplayObject):void
		{
			dropDown.removeEventListener(DateChooserEvent.DATE_SELECTED, dateSelectedHandler);
			
			super.removePopupDropDown(dropDown);
		}
		
		private function dateSelectedHandler(event:DateChooserEvent):void
		{
			selectedDate = new Date(event.year, event.month, event.date);
			closeDropDown();
			
			if(hasEventListener(event.type))
			{
				dispatchEvent(event);
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_selectedDateChangedFlag)
			{
				_selectedDateChangedFlag = false;
				
				textInput.text = formatValueToString(_selectedDate);

				if(dropDownTarget != null)
				{
					if(isDropDownOpen)
					{
						DateChooser(dropDownTarget).selectedDate = _selectedDate;	
					}
				}
			}
		}

		override protected function measure():void
		{
			super.measure();
		
			var gap:Number = getStyle("gap") || 0;
			
			var textInputMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(textInput);
			var textInputMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(textInput);
			
			var textInputMinW:Number = LayoutUtil.getDisplayObjectMinWidth(textInput);
			var textInputMinH:Number = LayoutUtil.getDisplayObjectMinHeight(textInput);
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			var measuredW:Number = textInputMW + gap + openButtonMW;
			var measuredH:Number = Math.max(textInputMH, openButtonMH);
			
			var measuredMinW:Number = textInputMinW + gap + openButtonMW;
			var measuredMinH:Number = Math.max(textInputMinH, openButtonMH);
			
			setMeasuredSize(measuredW, measuredH);
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			var gap:Number = getStyle("gap") || 0;
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			LayoutUtil.setDisplayObjectSize(textInput, layoutWidth - openButtonMW - gap, layoutHeight);
			
			LayoutUtil.setDisplayObjectLayout(openButton, 
				layoutWidth - openButtonMW, (layoutHeight - openButtonMH) * 0.5, 
				openButtonMW, openButtonMH);
		}
		
		private function formatValueToString(value:Date):String
		{
			var formattedValue:String;
			
			if(_textFormatFunction != null)
			{
				formattedValue = _textFormatFunction(value);
			}
			else
			{
				formattedValue = value.fullYear + "/" + value.month + "/" + value.date;
			}
			
			return formattedValue;
		}
		
		//event
		private function openButtonMouseDownHandler(event:MouseEvent):void
		{
			openDropDown();
		}
    }
}