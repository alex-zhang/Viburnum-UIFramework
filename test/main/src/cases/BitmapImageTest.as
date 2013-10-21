package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Button;
	import com.viburnum.components.Container;
	import com.viburnum.components.BitmapFillMode;
	import com.viburnum.components.BitmapImage;
	
	import flash.events.MouseEvent;

	public class BitmapImageTest extends ComponentTestBase
	{
		public function BitmapImageTest()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();
			
			var bitmapImage:BitmapImage = new BitmapImage();
			bitmapImage.percentWidth = 1;
			bitmapImage.percentHeight = 1;
			bitmapImage.source = AssetsReference.assets3;
			bitmapImage.fillMode = BitmapFillMode.REPEAT;
			
			componentContainer.addChild(bitmapImage);
			
			//--
			
			var setpercentSizeBtn0:Button = new Button();
			setpercentSizeBtn0.label = "percent 0.8";
			controlContainer.addChild(setpercentSizeBtn0);
			setpercentSizeBtn0.addEventListener(MouseEvent.CLICK, setpercentSizeBtn0ClickHandler);
			function setpercentSizeBtn0ClickHandler():void
			{
				bitmapImage.percentWidth = 0.8;
				bitmapImage.percentHeight = 0.8;
			}
			
			var setpercentSizeBtn1:Button = new Button();
			setpercentSizeBtn1.label = "percent 1";
			controlContainer.addChild(setpercentSizeBtn1);
			setpercentSizeBtn1.addEventListener(MouseEvent.CLICK, setpercentSize1BtnClickHandler);
			function setpercentSize1BtnClickHandler():void
			{
				bitmapImage.percentWidth = 1;
				bitmapImage.percentHeight = 1;
			}
			
			var sourceBtn0:Button = new Button();
			sourceBtn0.label = "source BG_sgs_zbbj_blcd001";
			controlContainer.addChild(sourceBtn0);
			sourceBtn0.addEventListener(MouseEvent.CLICK, sourceBtn0ClickHandler);
			function sourceBtn0ClickHandler():void
			{
				bitmapImage.source = AssetsReference.assets3;
			}
			
			var sourceBtn1:Button = new Button();
			sourceBtn1.label = "source back002";
			controlContainer.addChild(sourceBtn1);
			sourceBtn1.addEventListener(MouseEvent.CLICK, sourceBtn1ClickHandler);
			function sourceBtn1ClickHandler():void
			{
				bitmapImage.source = AssetsReference.assets3;
			}
			
			var sourceBtn2:Button = new Button();
			sourceBtn2.label = "source Penguins";
			controlContainer.addChild(sourceBtn2);
			sourceBtn2.addEventListener(MouseEvent.CLICK, sourceBtn2ClickHandler);
			function sourceBtn2ClickHandler():void
			{
				bitmapImage.source = AssetsReference.assets3;
			}
			
			var repeatBtn:Button = new Button();
			repeatBtn.label = "REPEAT";
			controlContainer.addChild(repeatBtn);
			repeatBtn.addEventListener(MouseEvent.CLICK, repeatBtnClickHandler);
			function repeatBtnClickHandler():void
			{
				bitmapImage.fillMode = BitmapFillMode.REPEAT;
			}
			
			var scaleBtn:Button = new Button();
			scaleBtn.label = "SCALE";
			controlContainer.addChild(scaleBtn);
			scaleBtn.addEventListener(MouseEvent.CLICK, scaleBtnClickHandler);
			function scaleBtnClickHandler():void
			{
				bitmapImage.fillMode = BitmapFillMode.SCALE;
			}
			
			var clipBtn:Button = new Button();
			clipBtn.label = "CLIP";
			controlContainer.addChild(clipBtn);
			clipBtn.addEventListener(MouseEvent.CLICK, clipBtnClickHandler);
			function clipBtnClickHandler():void
			{
				bitmapImage.fillMode = BitmapFillMode.CLIP;
			}
			
			var smoothBitmapContentBtn:Button = new Button();
			smoothBitmapContentBtn.label = "smoothBitmapContent";
			controlContainer.addChild(smoothBitmapContentBtn);
			smoothBitmapContentBtn.addEventListener(MouseEvent.CLICK, smoothBitmapContentBtnClickHandler);
			function smoothBitmapContentBtnClickHandler():void
			{
				bitmapImage.smoothBitmapContent = !bitmapImage.smoothBitmapContent;
			}
		}
	}
}