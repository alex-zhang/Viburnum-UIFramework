package com.viburnum.components
{
	import com.viburnum.components.baseClasses.NumericStepperBase;
	import com.viburnum.events.ViburnumMouseEvent;
	import com.viburnum.utils.LayoutUtil;

	[Style(name="repeatInterval", type="Number", format="Time", minValue="0.0")]
	
	[Style(name="incrementButton_backgroundSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_upSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_overSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_downSkin", type="Class")]
	[Style(name="incrementButton_backgroundSkin_disabledSkin", type="Class")]
	
	[Style(name="decrementButton_backgroundSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_upSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_overSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_downSkin", type="Class")]
	[Style(name="decrementButton_backgroundSkin_disabledSkin", type="Class")]
	
    public class NumericStepper extends NumericStepperBase implements IFocusManagerComponent
    {
		protected var incrementButton:SimpleButton;
		protected var decrementButton:SimpleButton;
		
        public function NumericStepper()
        {
            super();
        }
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			decrementButton = new SimpleButton();
			decrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, decrementButtonClickHandler);
			decrementButton.autoRepeat = true;
			decrementButton.enabled  = enabled;
			addChild(decrementButton);
			
			incrementButton = new SimpleButton();
			incrementButton.addEventListener(ViburnumMouseEvent.BUTTON_DOWN, incrementButtonClickHandler);
			incrementButton.autoRepeat = true;
			incrementButton.enabled  = enabled;
			addChild(incrementButton);
		}
		
		private function decrementButtonClickHandler(event:ViburnumMouseEvent):void
		{
			changeValueByStep(false);
		}
		
		private function incrementButtonClickHandler(event:ViburnumMouseEvent):void
		{
			changeValueByStep(true);
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "incrementButton_backgroundSkin" || 
				styleProp == "incrementButton_backgroundSkin_upSkin" ||
				styleProp == "incrementButton_backgroundSkin_overSkin" || 
				styleProp == "incrementButton_backgroundSkin_downSkin" ||
				styleProp == "incrementButton_backgroundSkin_disabledSkin")
			{
				var incrementButtonStyle:String = styleProp.substr(16);
				incrementButton.setStyle(incrementButtonStyle, getStyle(styleProp));
			}
			else if(styleProp == "decrementButton_backgroundSkin" || 
				styleProp == "decrementButton_backgroundSkin_upSkin" ||
				styleProp == "decrementButton_backgroundSkin_overSkin" || 
				styleProp == "decrementButton_backgroundSkin_downSkin" ||
				styleProp == "decrementButton_backgroundSkin_disabledSkin")
			{
				var decrementButtonStyle:String = styleProp.substr(16);
				decrementButton.setStyle(decrementButtonStyle, getStyle(styleProp));
			}
			else if(styleProp == "repeatInterval")
			{
				decrementButton.setStyle("repeatInterval", getStyle("repeatInterval"));
				incrementButton.setStyle("repeatInterval", getStyle("repeatInterval"));
			}
		}
		
		override protected function measure():void
		{
			super.measure();

			var textInputMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(textInput);
			var textInputMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(textInput);
			var textInputMinW:Number = LayoutUtil.getDisplayObjectMinWidth(textInput);
			var textInputMinH:Number = LayoutUtil.getDisplayObjectMinHeight(textInput);

			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(decrementButton);
			var decrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(decrementButton);
			var decrementButtonMinW:Number = LayoutUtil.getDisplayObjectMinWidth(decrementButton);
			var decrementButtonMinH:Number = LayoutUtil.getDisplayObjectMinHeight(decrementButton);
			
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(incrementButton);
			var incrementButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(incrementButton);
			var incrementButtonMinW:Number = LayoutUtil.getDisplayObjectMinWidth(incrementButton);
			var incrementButtonMinH:Number = LayoutUtil.getDisplayObjectMinHeight(incrementButton);
			
			var measuredW:Number = textInputMW + Math.max(decrementButtonMW, incrementButtonMW);
			var measuredH:Number = Math.max(textInputMH, decrementButtonMH + incrementButtonMH);
			
			setMeasuredSize(measuredW, measuredH);
			
			//--

			var minW:Number = textInputMinW + Math.max(decrementButtonMinW, incrementButtonMinW);
			var minH:Number = Math.max(textInputMinH, decrementButtonMinH + incrementButtonMinH);
			
			setMeasuredMinSize(minW, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			var decrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(decrementButton);
			var incrementButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(incrementButton);

			var btnW:Number = Math.max(decrementButtonMW, incrementButtonMW);
			var btnH:Number = layoutHeight * 0.5;

			var textInputW:Number = layoutWidth - btnW;
			
			LayoutUtil.setDisplayObjectSize(textInput, textInputW, layoutHeight);
			
			LayoutUtil.setDisplayObjectLayout(decrementButton, 
				layoutWidth - btnW, 0, btnW, btnH);
			
			LayoutUtil.setDisplayObjectLayout(incrementButton, 
				layoutWidth - btnW, layoutHeight - btnH, btnW, btnH);
		}
    }
}