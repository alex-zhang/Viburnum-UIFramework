package com.viburnum.components
{
	import com.viburnum.components.baseClasses.DropDownListBase;
	import com.viburnum.utils.LayoutUtil;

	[Style(name="popUp_iconSkin", type="Class")]
	[Style(name="popUp_iconSkin_upSkin", type="Class")]
	[Style(name="popUp_iconSkin_overSkin", type="Class")]
	[Style(name="popUp_iconSkin_downSkin", type="Class")]
	[Style(name="popUp_iconSkin_disabledSkin", type="Class")]

	[Style(name="popUpSkin", type="Class")]
	[Style(name="popUpUpSkin", type="Class")]
	[Style(name="popUpOverSkin", type="Class")]
	[Style(name="popUpDownSkin", type="Class")]
	[Style(name="popUpDisabledSkin", type="Class")]
	
	[Style(name="arrowButtonSkin", type="Class")]
	[Style(name="arrowButtonUpSkin", type="Class")]
	[Style(name="arrowButtonOverSkin", type="Class")]
	[Style(name="arrowButtonDownSkin", type="Class")]
	[Style(name="arrowButtonDisabledSkin", type="Class")]

	public class PopUpButton extends DropDownListBase
	{
		protected var popUpButton:Button;
		
		public function PopUpButton()
		{
			super();
		}

		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "popUp_iconSkin" || 
				styleProp == "popUp_iconSkin_upSkin" ||
				styleProp == "popUp_iconSkin_overSkin" || 
				styleProp == "popUp_iconSkin_downSkin" ||
				styleProp == "popUp_iconSkin_disabledSkin")
			{
				popUpButton.setStyle(styleProp.substr(6), getStyle(styleProp));
			}
			else if(styleProp == "popUpSkin" || 
				styleProp == "popUpUpSkin" ||
				styleProp == "popUpOverSkin" || 
				styleProp == "popUpDownSkin" ||
				styleProp == "popUpDisabledSkin")
			{
				var popUpButtonStyleName:String = "backgroundSkin";
				if(styleProp != "popUpSkin")
				{
					popUpButtonStyleName = styleProp.substr(5);
					popUpButtonStyleName = "backgroundSkin_" + popUpButtonStyleName.charAt(0).toLowerCase() + popUpButtonStyleName.substr(1);
				}
				
				popUpButton.setStyle(popUpButtonStyleName, getStyle(styleProp));
			}
			else if(styleProp == "arrowButtonSkin" || 
				styleProp == "arrowButtonUpSkin" ||
				styleProp == "arrowButtonOverSkin" || 
				styleProp == "arrowButtonDownSkin" ||
				styleProp == "arrowButtonDisabledSkin")
			{
				var openButtonStyleName:String = "backgroundSkin";
				if(styleProp != "arrowButtonSkin")
				{
					openButtonStyleName = styleProp.substr(11);
					
					openButtonStyleName = "backgroundSkin_" + 
						openButtonStyleName.charAt(0).toLowerCase() + 
						openButtonStyleName.substr(1);
				}
				
				openButton.setStyle(openButtonStyleName, getStyle(styleProp));
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			popUpButton = new Button();
			addChild(popUpButton);
			
			openButton = new SimpleButton();
			addChild(openButton);
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var popUpButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(popUpButton);;
			var popUpButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(popUpButton);
			
			var popUpButtonMinW:Number = LayoutUtil.getDisplayObjectMinWidth(popUpButton);
			var popUpButtonMinH:Number = LayoutUtil.getDisplayObjectMinHeight(popUpButton);
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			var measuredW:Number = popUpButtonMW + openButtonMW;
			var measuredH:Number = Math.max(popUpButtonMH, openButtonMH);
			
			var measuredMinW:Number = popUpButtonMW + openButtonMW;
			var measuredMinH:Number = Math.max(popUpButtonMinH, openButtonMH);
			
			setMeasuredSize(measuredW, measuredH);
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var openButtonMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(openButton);
			var openButtonMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(openButton);
			
			LayoutUtil.setDisplayObjectSize(popUpButton, layoutWidth - openButtonMW, layoutHeight);
			LayoutUtil.setDisplayObjectLayout(openButton, layoutWidth - openButtonMW, 0, openButtonMW, layoutHeight);
		}
	}
}