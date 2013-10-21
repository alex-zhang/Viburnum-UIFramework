package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Button;
	import com.viburnum.components.ToolTip;
	import com.viburnum.interfaces.IToolTip;
	import com.viburnum.layouts.FlowLayout;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.VerticalLayout;
	
	import flash.events.MouseEvent;
	
	public class ToolTipTest extends ComponentTestBase
	{
		public function ToolTipTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

			componentContainer.layout = new FlowLayout();
			
//			var toolTip:ToolTip = new ToolTip();
//			toolTip.toolTip = "阿萨德阿斯达斯达斯的撒大声的asdasdasd阿萨德阿萨德阿萨德阿萨德111111111111111111111111111111111\n1\n111111111111111111111111111111111111111111";
//			componentContainer.addChild(toolTip);
//			toolTip.visible = false;
//			
//			var bt1:Button = new Button();
//			bt1.label = "显示 UIcomponent 设置 的 ToolTip(1) 111111111111111111111111111111111111111111111111111111111111111111";
//			bt1.toolTip = bt1.label;
//			componentContainer.addChild(bt1);
			
			
			var bt1111:Button = new Button();
			bt1111.label = "重叠11111111";
			bt1111.toolTip = bt1111.label;
			bt1111.includeInLayout = false;
			componentContainer.addChild(bt1111);
			
			var bt2:Button = new Button();
			bt2.height = 50;
			bt2.x = 50;
			bt2.label = "显示 UIcomponent 设置 的 ToolTip(2)";
			bt2.toolTip = bt2.label;
			componentContainer.addChild(bt2);
			
			var bt3:Button = new Button();
			bt3.x = 90;
			bt3.label = "点击后,显示某个target的ToolTip aaaaaaaaaaaaaaaaaafdsfsfs fsdd";
			bt3.toolTip = bt3.label;
			componentContainer.addChild(bt3);
			bt3.addEventListener(MouseEvent.CLICK, bt3MouseClickHandler);
			function bt3MouseClickHandler():void
			{
			}
			
			var bt4:Button = new Button();
			bt4.x = 120;
			bt4.label = "点击后,立即显示某个target的ToolTip ";
			bt4.toolTip = bt4.label;
			componentContainer.addChild(bt4);
			bt4.addEventListener(MouseEvent.CLICK, bt4MouseClickHandler);
			function bt4MouseClickHandler():void
			{
				toolTipManager.showTargetToolTip(bt2, true);
			}
			
			//showToolTip
			var cusToolTip:IToolTip = null;
			
			var bt5:Button = new Button();
			bt5.x = 120;
			bt5.label = "显示自定的toolTip";
			componentContainer.addChild(bt5);
			bt5.addEventListener(MouseEvent.CLICK, bt5MouseClickHandler);
			function bt5MouseClickHandler():void
			{
				cusToolTip = new ToolTip();
				cusToolTip.toolTip = <![CDATA[( ⊙ o ⊙ )是的11111111111111111111111被爸爸爸爸爸爸111111111111111111111111111111111111111111111
( ⊙ o ⊙ )我靠( ‵o′)凸O(∩_∩)O谢谢（*@ο@*）
哇～( ⊙o⊙?)( ⊙o⊙ )千真万确( ⊙o⊙ )千真万确O(∩_∩)O谢谢
☂☃➹❀❉☭☣☢☢✲❉❉❉
				.-._     
				{_}^ )o  
				{\________//~`     
				(         )
				/||~~~~~||\
				|_\\_    \\_\_   
				"' ""'    ""'"'
]]>;
				toolTipManager.showCustomToolTip(cusToolTip, Math.random() * 600, Math.random() * 600);
			}
			
			//destroyCurrentToolTip
			var bt6:Button = new Button();
			bt6.x = 160;
			bt6.label = "移除当前ToolTip";
			bt6.toolTip = bt6.label;
			componentContainer.addChild(bt6);
			bt6.addEventListener(MouseEvent.CLICK, bt6MouseClickHandler);
			function bt6MouseClickHandler():void
			{
				toolTipManager.destroyCurrentToolTip();
			}

			//destroyAllToolTip
			var bt7:Button = new Button();
			bt7.x = 160;
			bt7.label = "移除当前所有自定ToolTip";
			bt7.toolTip = bt7.label;
			componentContainer.addChild(bt7);
			bt7.addEventListener(MouseEvent.CLICK, bt7MouseClickHandler);
			function bt7MouseClickHandler():void
			{
				toolTipManager.removeAllCustomToolTip();
			}
			
			//destroyToolTip
			var bt8:Button = new Button();
			bt8.x = 190;
			bt8.label = "移除当前自定义ToolTip";
			bt8.toolTip = bt8.label;
			componentContainer.addChild(bt8);
			bt8.addEventListener(MouseEvent.CLICK, bt8MouseClickHandler);
			function bt8MouseClickHandler():void
			{
				toolTipManager.removeCustomToolTip(cusToolTip);
			}
		}
	}
}