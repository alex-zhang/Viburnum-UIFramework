package com.viburnum.skins
{
	
	import com.viburnum.interfaces.IBorder;
	import com.viburnum.utils.EdgeMetrics;

	/*
	[Style(name="borderStyle", type="String", enumeration="solid,none", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="borderVisible", type="Boolean")]
	[Style(name="borderColor", type="uint", format="Color")]
	[Style(name="borderAlpha", type="Number")]
	[Style(name="borderWeight", type="Number", format="Length", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="cornerRadius", type="Number", format="Length")]
	
	[Style(name="dropShadowVisible", type="Boolean")]
	[Style(name="dropShadowAlpha", type="Number", format="Length")]
	[Style(name="dropShadowAngle", type="Number", format="Length")]
	[Style(name="dropShadowBlur", type="Number", format="Length")]
	[Style(name="dropShadowColor", type="uint", format="Color")]
	[Style(name="dropShadowDistance", type="Number", format="Length")]
	[Style(name="dropShadowStrength", type="Number", format="Length")]
	[Style(name="dropShadowInner", type="Boolean")]
	
	[Style(name="backgroundColor", type="uint", format="Color")]
	[Style(name="backgroundAlpha", type="Number")]
	[Style(name="backgroundImage", type="Class")]
	[Style(name="backgroundImageFillMode", type="String", enumeration="scale,clip,repeat")]
	*/

	//see include "../../style/styleMetadata/BorderStyle.as";
	
	public class DefaultBorderSkin extends DefaultBackgroundSkin implements IBorder
	{
		public function DefaultBorderSkin()
		{
			super();
		}

		//IBorder
		private var _borderMetrics:EdgeMetrics;
		
		public function get borderMetrics():EdgeMetrics
		{
			var borderStyle:String = getStyle("borderStyle");
			var borderWeight:Number = getStyle("borderWeight") || 0;
			if(borderStyle != "solid")
			{
				borderWeight = 0;
			}

			if(borderWeight == 0) return EdgeMetrics.EMPTY;
			
			if(!_borderMetrics) 
			{
				_borderMetrics = new EdgeMetrics(borderWeight, borderWeight, borderWeight, borderWeight)
			}
			else
			{
				_borderMetrics.left = borderWeight;
				_borderMetrics.right = borderWeight;
				_borderMetrics.top = borderWeight;
				_borderMetrics.bottom = borderWeight;
			}
			
			return _borderMetrics;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var measuredMinW:Number = borderMetrics.left + borderMetrics.right;
			var measuredMinH:Number = borderMetrics.top + borderMetrics.bottom;
			
			setMeasuredMinSize(measuredMinW, measuredMinH);
		}
		
		override protected function layoutBackgroundColor(layoutWidth:Number, layoutHeight:Number):void
		{
			var bl:Number = borderMetrics.left;
			var bt:Number = borderMetrics.right;
			var br:Number = borderMetrics.right;
			var bb:Number = borderMetrics.bottom;
			
			var contentW:Number = layoutWidth - bl - br;
			var contentH:Number = layoutHeight - bt - bb;
			
			var cornerRadius:Number = getStyle("cornerRadius") || 0;
			
			//--
			if(layoutWidth != contentW || contentW != contentH)
			{
				var borderAlpha:Number = getStyle("borderAlpha") || 0;
				var borderWeight:Number = getStyle("borderWeight") || 0;
				var borderColor:uint = getStyle("borderColor");
				
				graphics.beginFill(borderColor, borderAlpha);
				graphics.drawRoundRectComplex(0, 0, layoutWidth, layoutHeight, 
					cornerRadius, 
					cornerRadius, 
					cornerRadius, 
					cornerRadius);
			}
			
			//--
			var backgroundAlpha:Number = getStyle("backgroundAlpha") || 0;
			var backgroundColor:uint = getStyle("backgroundColor") || 0;
			
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRoundRectComplex(bl, bt, contentW, contentH, 
				cornerRadius, 
				cornerRadius, 
				cornerRadius, 
				cornerRadius);
		}
		
		override protected function layoutBackground(layoutWidth:Number, layoutHeight:Number):void
		{
			var borderVisible:Boolean = getStyle("borderVisible");
			
			if(borderVisible)
			{
				layoutBackgroundColor(layoutWidth, layoutHeight);
			}
			
			var hasBackgroundImage:Boolean = getStyle("backgroundImage") != null;
			if(hasBackgroundImage)
			{
				layoutBackgroundImage(layoutWidth, layoutHeight);
			}
		}
		
		override protected function layoutBackgroundImage(layoutWidth:Number, layoutHeight:Number):void
		{
			layoutWidth -= borderMetrics.left;
			layoutHeight -= borderMetrics.top;
			
			super.layoutBackgroundImage(layoutWidth, layoutHeight);
		}
	}
}