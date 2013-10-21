package com.viburnum.components
{
	import com.viburnum.components.baseClasses.ButtonBase;
	import com.viburnum.events.ViburnumEvent;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.events.MouseEvent;

	//没有文字和Icon简单的背景
	public class SimpleButton extends ButtonBase implements IToggleButton
	{
		private var _selected:Boolean = false;
		private var _isToggleEnable:Boolean = false;

		public function SimpleButton()
		{
			super();
		}
		
		public function get toggleEnable():Boolean
		{
			return _isToggleEnable;
		}
		
		[Inspectable(type="Boolean")]
		public function set toggleEnable(value:Boolean):void
		{
			_isToggleEnable = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		[Inspectable(type="Boolean")]
		public function set selected(value:Boolean):void
		{
			if(_selected != value)
			{
				_selected = value;
				currentState = getCurrentSkinState();
				
				if(hasEventListener(ViburnumEvent.VALUE_CHANGED))
				{
					dispatchEvent(new ViburnumEvent(ViburnumEvent.VALUE_CHANGED));
				}
			}
		}
		
		override protected function getCurrentSkinState():String//up over down disable
		{
			var buttonState:String = super.getCurrentSkinState();
			if(!_selected)
			{
				return buttonState;
			}
			else
			{
				return "selected_" + buttonState;
			}
		}
		
		override protected function measure():void
		{
			super.measure();

			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var gapW:Number = bl + br + pl + pr;
			var gapH:Number = bt + bb + pt + pb;
			
			var iconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(iconSkin);
			var iconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(iconSkin);

			var backgroundSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(backgroundSkin);
			var backgroundSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(backgroundSkin);
			//--
			
			var measuredMW:Number = Math.max(iconSkinMW + pl + pr, backgroundSkinMW);
			var measuredMH:Number = Math.max(iconSkinMH + pt + pb, backgroundSkinMH);
			
			measuredMW += bl + br;
			measuredMH += bt + bb;
			
			setMeasuredSize(measuredMW, measuredMH);
			
			//--
			var minW:Number = gapW + iconSkinMW;
			var minH:Number = gapH + iconSkinMH;
			
			setMeasuredMinSize(minW, minH);
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var gapW:Number = bl + br + pl + pr;
			var gapH:Number = bt + bb + pt + pb;
			
			var left:Number = pl + bl;
			var top:Number = pt + bt;
			
			var iconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(iconSkin);
			var iconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(iconSkin);
			
			//--
			var contenWidth:Number = layoutWidth - gapW;
			var contenHeight:Number = layoutHeight - gapH;
			
			LayoutUtil.setDisplayObjectPosition(iconSkin, left + (contenWidth - iconSkinMW) / 2, top + (contenHeight - iconSkinMH) / 2);
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			
			if(enabled &&  _isToggleEnable)
			{
				selected = !selected;
			}
		}
	}
}