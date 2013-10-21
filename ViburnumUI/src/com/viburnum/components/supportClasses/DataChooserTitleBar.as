package com.viburnum.components.supportClasses
{
	import com.viburnum.components.Label;
	import com.viburnum.components.SimpleButton;
	import com.viburnum.components.Space;
	import com.viburnum.components.VGroup;
	import com.viburnum.components.baseClasses.TitleBarBase;
	import com.viburnum.events.DateChooserEvent;
	import com.viburnum.events.ViburnumMouseEvent;
	import com.viburnum.layouts.VerticalLayout;

	[Style(name="prevMonthButtonSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_upSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_overSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_downSkin", type="Class")]
	[Style(name="prevMonthButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="prevYearButtonSkin", type="Class")]
	[Style(name="prevYearButtonSkin_upSkin", type="Class")]
	[Style(name="prevYearButtonSkin_overSkin", type="Class")]
	[Style(name="prevYearButtonSkin_downSkin", type="Class")]
	[Style(name="prevYearButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="nextYearButtonSkin", type="Class")]
	[Style(name="nextYearButtonSkin_upSkin", type="Class")]
	[Style(name="nextYearButtonSkin_overSkin", type="Class")]
	[Style(name="nextYearButtonSkin_downSkin", type="Class")]
	[Style(name="nextYearButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="yearLabelStyleName", type="String")]
	[Style(name="monthLabelStyleName", type="String")]
	
	[Style(name="nextMonthButtonSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_upSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_overSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_downSkin", type="Class")]
	[Style(name="nextMonthButtonSkin_disabledSkin", type="Class")]
	
	[Style(name="repeatInterval", type="Number", format="Time", minValue="0.0")]
	
	public class DataChooserTitleBar extends TitleBarBase
	{
		protected var prevMonthSimpleButton:SimpleButton;
		protected var prevYearSimpleButton:SimpleButton;
		protected var nextYearSimpleButton:SimpleButton;
		protected var yearLabel:Label;
		protected var monthLabel:Label;
		protected var nextMonthSimpleButton:SimpleButton;

		private var _yearText:String;
		private var _yearTextChangedFlag:Boolean = false;
		
		private var _monthText:String;
		private var _monthTextChangedFlag:Boolean = false;
		
		public function DataChooserTitleBar()
		{
			super();
		}
		
		public function get yearText():String
		{
			return _yearText;
		}
		
		public function set yearText(value:String):void
		{
			if(_yearText != value)
			{
				_yearText = value;
				
				_yearTextChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get monthText():String
		{
			return _monthText;
		}
		
		public function set monthText(value:String):void
		{
			if(_monthText != value)
			{
				_monthText = value;
				
				_monthTextChangedFlag = true;
				invalidateProperties();
			}
		}

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "prevMonthButtonSkin" || styleProp == "prevMonthButtonSkin_upSkin" || 
				styleProp == "prevMonthButtonSkin_overSkin" || styleProp == "prevMonthButtonSkin_downSkin" || 
				styleProp == "prevMonthButtonSkin_disabledSkin")
			{
				var prevMonthStyleProp:String = styleProp.replace(/prevMonthButton/, "background");
				prevMonthSimpleButton.setStyle(prevMonthStyleProp, getStyle(styleProp));
			}
			else if(styleProp == "prevYearButtonSkin" || styleProp == "prevYearButtonSkin_upSkin" || 
				styleProp == "prevYearButtonSkin_overSkin" || styleProp == "prevYearButtonSkin_downSkin" || 
				styleProp == "prevYearButtonSkin_disabledSkin")
			{
				var prevYearStyleProp:String = styleProp.replace(/prevYearButton/, "background");
				prevYearSimpleButton.setStyle(prevYearStyleProp, getStyle(styleProp));
			}
			else if(styleProp == "nextYearButtonSkin" || styleProp == "nextYearButtonSkin_upSkin" || 
				styleProp == "nextYearButtonSkin_overSkin" || styleProp == "nextYearButtonSkin_downSkin" || 
				styleProp == "nextYearButtonSkin_disabledSkin")
			{
				var nextYearStyleProp:String = styleProp.replace(/nextYearButton/, "background");
				nextYearSimpleButton.setStyle(nextYearStyleProp, getStyle(styleProp));
			}
			else if(styleProp == "yearLabelStyleName")
			{
				yearLabel.styleName = getStyle(styleProp);
			}
			else if(styleProp == "monthLabelStyleName")
			{
				monthLabel.styleName = getStyle(styleProp);
			}
			else if(styleProp == "nextMonthButtonSkin" || styleProp == "nextMonthButtonSkin_upSkin" || 
				styleProp == "nextMonthButtonSkin_overSkin" || styleProp == "nextMonthButtonSkin_downSkin" || 
				styleProp == "nextMonthButtonSkin_disabledSkin")
			{
				var nextMothStyleProp:String = styleProp.replace(/nextMonthButton/, "background");
				nextMonthSimpleButton.setStyle(nextMothStyleProp, getStyle(styleProp));
			}
			else if(styleProp == "repeatInterval")
			{
				prevMonthSimpleButton.setStyle(styleProp, getStyle(styleProp));
				nextMonthSimpleButton.setStyle(styleProp, getStyle(styleProp));
				prevYearSimpleButton.setStyle(styleProp, getStyle(styleProp));
				nextYearSimpleButton.setStyle(styleProp, getStyle(styleProp));
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			prevMonthSimpleButton = new SimpleButton();
			prevMonthSimpleButton.name = "prevMonthSimpleButton";
			prevMonthSimpleButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, prevMonthSimpleButtonButtonDownHandler);
			prevMonthSimpleButton.autoRepeat = true;
			addContentChild(prevMonthSimpleButton);
			
			var space0:Space = new Space();
			space0.percentWidth = 1;
			addContentChild(space0);
			
			//groug btn
			var yearButtonGroup:VGroup = new VGroup();
			VerticalLayout(yearButtonGroup.layout).gap = 0;
			addContentChild(yearButtonGroup);
			
			prevYearSimpleButton = new SimpleButton();
			prevYearSimpleButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, prevYearSimpleButtonButtonDownHandler);
			prevYearSimpleButton.autoRepeat = true;
			yearButtonGroup.addChild(prevYearSimpleButton);

			nextYearSimpleButton = new SimpleButton();
			nextYearSimpleButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, nextYearSimpleButtonButtonDownHandler);
			nextYearSimpleButton.autoRepeat = true;
			yearButtonGroup.addChild(nextYearSimpleButton);
			//--
			
			var space1:Space = new Space();
			space1.width = 5;
			addContentChild(space1);
			
			yearLabel = new Label();
			addContentChild(yearLabel);

			var space2:Space = new Space();
			space2.percentWidth = 1;
			addContentChild(space2);

			monthLabel = new Label();
			addContentChild(monthLabel);
			
			var space3:Space = new Space();
			space3.percentWidth = 1;
			addContentChild(space3);
			
			nextMonthSimpleButton = new SimpleButton();
			nextMonthSimpleButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, nextMonthSimpleButtonButtonDownHandler);
			nextMonthSimpleButton.autoRepeat = true;
			addContentChild(nextMonthSimpleButton);
		}

		private function prevMonthSimpleButtonButtonDownHandler(event:ViburnumMouseEvent):void
		{
			if(hasEventListener(DateChooserEvent.PREV_MONTH_BUTTON_CLICK))
			{
				dispatchEvent(new DateChooserEvent(DateChooserEvent.PREV_MONTH_BUTTON_CLICK));
			}
		}
		
		private function nextMonthSimpleButtonButtonDownHandler(event:ViburnumMouseEvent):void
		{
			if(hasEventListener(DateChooserEvent.NEXT_MONTH_BUTTON_CLICK))
			{
				dispatchEvent(new DateChooserEvent(DateChooserEvent.NEXT_MONTH_BUTTON_CLICK));
			}
		}
		
		private function prevYearSimpleButtonButtonDownHandler(event:ViburnumMouseEvent):void
		{
			if(hasEventListener(DateChooserEvent.PREV_YEAR_BUTTON_CLICK))
			{
				dispatchEvent(new DateChooserEvent(DateChooserEvent.PREV_YEAR_BUTTON_CLICK));
			}
		}
		
		private function nextYearSimpleButtonButtonDownHandler(event:ViburnumMouseEvent):void
		{
			if(hasEventListener(DateChooserEvent.NEXT_YEAR_BUTTON_CLICK))
			{
				dispatchEvent(new DateChooserEvent(DateChooserEvent.NEXT_YEAR_BUTTON_CLICK));
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_yearTextChangedFlag)
			{
				_yearTextChangedFlag = false;
				
				yearLabel.text = _yearText;
			}
			
			if(_monthTextChangedFlag)
			{
				_monthTextChangedFlag = false;
				
				monthLabel.text = _monthText;
			}
		}
	}
}