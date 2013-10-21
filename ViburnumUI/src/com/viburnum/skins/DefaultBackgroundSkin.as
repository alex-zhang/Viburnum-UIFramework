package com.viburnum.skins
{
	import com.viburnum.core.BitmapImage;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;

	/*[Style(name="backgroundAlpha", type="Number")]
	[Style(name="backgroundColor", type="uint", format="Color")]
	[Style(name="backgroundImage", type="Class")]
	[Style(name="backgroundImageFillMode", type="String", enumeration="scale,clip,repeat")]
	[Style(name="dropShadowVisible", type="Boolean")]
	[Style(name="dropShadowAlpha", type="Number", format="Length")]
	[Style(name="dropShadowAngle", type="Number", format="Length")]
	[Style(name="dropShadowBlur", type="Number", format="Length")]
	[Style(name="dropShadowColor", type="uint", format="Color")]
	[Style(name="dropShadowDistance", type="Number", format="Length")]
	[Style(name="dropShadowStrength", type="Number", format="Length")]
	[Style(name="dropShadowInner", type="Boolean")]*/

	//see include "../style/styleMetadata/BackgroundStyle.as";
	
	public class DefaultBackgroundSkin extends SkinsProgrammaticSkin
	{
		public var backgroundImage:BitmapImage;
		protected var myMaskBackgroundImageRect:Rectangle = new Rectangle();
		
		public function DefaultBackgroundSkin()
		{
			super();
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			backgroundImage = new BitmapImage();
			backgroundImage.fillMode = getStyle("backgroundImageFillMode");
			backgroundImage.source = getStyle("backgroundImage");
			addChild(backgroundImage);
			
			updateDropShowFilter();
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			super.notifyStyleChanged(styleProp);
			
			if(styleProp == "backgroundImage")
			{
				backgroundImage.source = getStyle("backgroundImage");
			}
			else if(styleProp == "dropShadowVisible" ||
				styleProp == "dropShadowAlpha" ||
				styleProp == "dropShadowAngle" ||
				styleProp == "dropShadowBlur" ||
				styleProp == "dropShadowColor" ||
				styleProp == "dropShadowDistance" ||
				styleProp == "dropShadowStrength" ||
				styleProp == "dropShadowInner")
			{
				updateDropShowFilter();
			}
			else if(styleProp == "backgroundImageFillMode")
			{
				backgroundImage.fillMode = getStyle("backgroundImageFillMode");
			}
		}
		
		protected function updateDropShowFilter():void
		{
			var dropShadowVisible:Boolean = getStyle("dropShadowVisible");
			var dropShadowAlpha:Number = getStyle("dropShadowAlpha");
			
			if(dropShadowVisible && dropShadowAlpha != 0)
			{
				var dropShadowAngle:Number = getStyle("dropShadowAngle") || 90;
				var dropShadowBlur:Number = getStyle("dropShadowBlur");
				var dropShadowColor:uint = getStyle("dropShadowColor");
				var dropShadowDistance:Number = getStyle("dropShadowDistance");
				var dropShadowStrength:Number = getStyle("dropShadowStrength") || 1;
				var dropShadowInner:Boolean = getStyle("dropShadowInner");
				if(this.filters == null || this.filters.length == 0)
				{
					this.filters = [new DropShadowFilter(dropShadowDistance, 
						dropShadowAngle, 
						dropShadowColor,
						dropShadowAlpha, 
						dropShadowBlur, 
						dropShadowBlur, 
						dropShadowStrength, 2, dropShadowInner)];			
				}
			}
			else
			{
				this.filters = null;
			}
		}

		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);

			layoutBackground(layoutWidth, layoutHeight);
		}
		
		protected function layoutBackground(layoutWidth:Number, layoutHeight:Number):void
		{
			var hasBackgroundImage:Boolean = getStyle("backgroundImage") != null;
			
			if(hasBackgroundImage)
			{
				layoutBackgroundImage(layoutWidth, layoutHeight);
			}
			else
			{
				graphics.clear();
				layoutBackgroundColor(layoutWidth, layoutHeight);
				graphics.endFill();
			}
		}
		
		protected function layoutBackgroundColor(layoutWidth:Number, layoutHeight:Number):void
		{
			var backgroundAlpha:Number = getStyle("backgroundAlpha") || 0;
			var backgroundColor:uint = getStyle("backgroundColor");
			
			if(backgroundAlpha != 0)
			{
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRect(0, 0, layoutWidth, layoutHeight);
			}
		}
		
		protected function layoutBackgroundImage(layoutWidth:Number, layoutHeight:Number):void
		{
			LayoutUtil.setDisplayObjectSize(backgroundImage, layoutWidth, layoutHeight);
			
			myMaskBackgroundImageRect.width = layoutWidth;
			myMaskBackgroundImageRect.height = layoutHeight;
			backgroundImage.scrollRect = myMaskBackgroundImageRect;
		}
	}
}