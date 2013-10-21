package com.viburnum.components
{
    import com.viburnum.components.baseClasses.ButtonBase;
    import com.viburnum.components.baseClasses.TextBase;
    import com.viburnum.utils.LayoutUtil;

	include "../style/styleMetadata/PaddingStyle.as";
	include "../style/styleMetadata/GapStyle.as";
	
    public class Button extends ButtonBase implements IFocusManagerComponent
    {
		public static function getStyleDefinition():Object 
		{
			return [
				//PaddingStyle
				{name:"paddingLeft", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingRight", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingTop", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				{name:"paddingBottom", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
				
				//GapStyle
				{name:"gap", type:"Number", invalidateSize:"true", invalidateDisplayList:"true"},
			]
		}
		
		private var _label:String = null;
        private var _labelChangedFlag:Boolean = false;

		protected var labelTextFiled:TextBase;
		
		private var _labelPlacement:String = ButtonLabelPlacement.RIGHT;
		
        public function Button()
        {
            super();
			
			label = "Botton";
        }

		public function get label():String
		{
			return _label;
		}
		
		[Inspectable(type="String", defaultValue="Botton")]
		public function set label(value:String):void
		{
			if(_label != value)
			{
				_label = value;
				_labelChangedFlag = true;
				
				invalidateProperties();
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		public function get labelPlacement():String
		{
			return _labelPlacement;
		}
		
		[Inspectable(defaultValue="right", enumeration="right, bottom, left, top")]
		public function set labelPlacement(value:String):void
		{
			if(_labelPlacement != value)
			{
				_labelPlacement = value;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		override public function validateSize():void
		{
			super.validateSize()
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			labelTextFiled = new Label();
			addChild(labelTextFiled);
		}

		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_labelChangedFlag)
			{
				_labelChangedFlag = false;
				
				labelTextFiled.text = _label || "";
			}
		}

		override protected function measure():void
		{
			super.measure();
			
			var gap:Number = getStyle("gap") || 0;

			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;

			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;

			var labelTextMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(labelTextFiled);
			var labelTextMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(labelTextFiled);
			
			var labelTextMinW:Number = LayoutUtil.getDisplayObjectMinWidth(labelTextFiled);
			var labelTextMinH:Number = LayoutUtil.getDisplayObjectMinHeight(labelTextFiled);
			
			var iconMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(iconSkin);
			var iconMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(iconSkin);

			var backgroundSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(backgroundSkin);
			var backgroundSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(backgroundSkin);

			var gapW:Number = bl + br + pl + pr;
			var gapH:Number = bt + bb + pt + pb;
			
			//--
			
			var contentMW:Number = 0;
			var contentMH:Number = 0;
			
			var contentMinW:Number = 0;
			var contentMinH:Number = 0;
			
			if(_labelPlacement == ButtonLabelPlacement.LEFT || 
				_labelPlacement == ButtonLabelPlacement.RIGHT)
			{
				contentMW = labelTextMW + iconMW;
				contentMH = Math.max(labelTextMH, iconMH);
				
				contentMinW = labelTextMinW + iconMW;
				contentMinH = Math.max(labelTextMinH, iconMH);
				
				if(iconMW != 0)
				{
					contentMW += gap;
					contentMinW += gap;
				}
			}
			else if(_labelPlacement == ButtonLabelPlacement.TOP || _labelPlacement == ButtonLabelPlacement.BOTTOM)
			{
				contentMW = Math.max(labelTextMW, iconMW);
				contentMH = labelTextMH + iconMH;
				
				contentMinW = Math.max(labelTextMinW, iconMW);
				contentMinH = labelTextMinH + iconMH;
				
				if(iconMH != 0)
				{
					contentMH += gap;
					contentMinH += gap;
				}
			}

			//--
			
			var measuredMW:Number = contentMW == 0 ? 
				backgroundSkinMW + bl + br :
				contentMW + gapW;
			
			var measuredMH:Number = contentMH == 0 ?
				backgroundSkinMH + bt + bb :
				contentMH + gapH;

			setMeasuredSize(measuredMW, measuredMH);
			
			//--
			
			var minW:Number = gapW + contentMinW;
			var minH:Number = gapH + contentMinH;
			
			setMeasuredMinSize(minW, minH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			var gap:Number = getStyle("gap") || 0;
			
			var bl:Number = borderMetrics.left;
			var br:Number = borderMetrics.right;
			var bt:Number = borderMetrics.top;
			var bb:Number = borderMetrics.bottom;
			
			var pl:Number = getStyle("paddingLeft") || 0;
			var pt:Number = getStyle("paddingTop") || 0;
			var pr:Number = getStyle("paddingRight") || 0;
			var pb:Number = getStyle("paddingBottom") || 0;

			var left:Number = pl + bl;
			var top:Number = pt + bt;
			var right:Number = pr + br;
			var bottom:Number = pb + bb;

			var gapW:Number = bl + br + pl + pr;
			var gapH:Number = bt + bb + pt + pb;

			var contentWidth:Number = layoutWidth - gapW;
			var contentHeight:Number = layoutHeight - gapH;

			var iconMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(iconSkin);
			var iconMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(iconSkin);
			
			var labelTextMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(labelTextFiled);
			var labelTextMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(labelTextFiled);
			
			//--

			var labelTextFiledOffx:Number = 0;
			var labelTextFiledOffy:Number = 0;
			var labelTextFiledW:Number = 0;
			var labelTextFiledH:Number = 0;

			var iconOffx:Number = 0;
			var iconOffy:Number = 0;

			if(_labelPlacement == ButtonLabelPlacement.LEFT)
			{
				iconOffx = layoutWidth - iconMW - right;
				iconOffy = top + (contentHeight - iconMH) / 2;

				labelTextFiledW = contentWidth - iconMW;
				labelTextFiledH = labelTextMH;
				labelTextFiledOffx = left;
				labelTextFiledOffy = top + (contentHeight - labelTextMH) / 2;

				if(iconMW != 0)
				{
					labelTextFiledW -= gap;
				}
			}
			else if(_labelPlacement == ButtonLabelPlacement.RIGHT)
			{
				iconOffx = left;
				iconOffy = top + (contentHeight - iconMH) / 2;
				
				labelTextFiledOffx = left + iconMW;
				labelTextFiledOffy = top + (contentHeight - labelTextMH) / 2;
				labelTextFiledW = contentWidth - iconMW;
				labelTextFiledH = labelTextMH;

				if(iconMW != 0)
				{
					labelTextFiledOffx += gap;
					labelTextFiledW -= gap;
				}
			}
			else if(_labelPlacement == ButtonLabelPlacement.TOP)
			{
				iconOffx = left + (contentWidth - iconMW) / 2;
				iconOffy = layoutHeight - iconMH - bottom;
				
				labelTextFiledOffx = left + (contentWidth - labelTextMW) / 2;
				labelTextFiledOffy = top;
				labelTextFiledW = labelTextMW;
				labelTextFiledH = contentHeight - iconMH;
				
				if(iconMH != 0)
				{
					labelTextFiledH -= gap;
				}
			}
			else if(_labelPlacement == ButtonLabelPlacement.BOTTOM)
			{
				iconOffx = left + (contentWidth - iconMW) / 2;
				iconOffy = top;
				
				labelTextFiledOffx = pl + (contentWidth - labelTextMW) / 2;
				labelTextFiledOffy = pt + iconMH;
				labelTextFiledW = labelTextMW;
				labelTextFiledH = contentHeight - iconMH;
				if(iconMH != 0)
				{
					labelTextFiledH -= gap;
					labelTextFiledOffy += gap;
				}
			}
			
			LayoutUtil.setDisplayObjectLayout(iconSkin, iconOffx, iconOffy, iconMW, iconMH);
			
			LayoutUtil.setDisplayObjectLayout(labelTextFiled, 
				labelTextFiledOffx, labelTextFiledOffy, 
				labelTextFiledW, labelTextFiledH);
		}
    }
}