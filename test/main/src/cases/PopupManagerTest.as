package cases
{
	import cases.supportClasses.ComponentTestBase;
	
	import com.viburnum.components.Alert;
	import com.viburnum.components.BorderContainer;
	import com.viburnum.components.Button;
	import com.viburnum.components.DateChooser;
	import com.viburnum.components.Menu;
	import com.viburnum.components.Panel;
	import com.viburnum.components.TitleWindow;
	import com.viburnum.core.PositionConstrainType;
	import com.viburnum.data.ArrayList;
	import com.viburnum.data.IList;
	import com.viburnum.data.TreeList;
	import com.viburnum.layouts.FlowLayout;
	import com.viburnum.managers.IPopupManager;
	import com.viburnum.utils.ArrayUtil;
	
	import flash.events.MouseEvent;

	public class PopupManagerTest extends ComponentTestBase
	{
		public function PopupManagerTest()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			componentContainer.layout = new FlowLayout();

			var bt1:Button = new Button();
			bt1.label = "popup center, always";
			componentContainer.addChild(bt1);
			bt1.addEventListener(MouseEvent.CLICK, bt1MouseClickHandler);
			function bt1MouseClickHandler():void
			{
				var window3:TitleWindow = new TitleWindow();
//				window3.icon = AssetsReference.assets5;
				window3.setStyle("titleIcon", AssetsReference.assets3);
				window3.allowCloseWhenPopup = true;
				window3.title = "Title Window1 isAlwaysPopupCenter true";
//				window3.width = 500;
//				window3.height = 300;
				
				popupManager.addPopUp(window3, false);
				popupManager.constrainPostion(window3, PositionConstrainType.CENTER, true);
			}
			
			function dddHandkler(event:MouseEvent):void
			{
				bt1MouseClickHandler();
			}
			
			var bt2:Button = new Button();
			bt2.x = 200;
			bt2.label = "popup center 2";
			componentContainer.addChild(bt2);
			bt2.addEventListener(MouseEvent.CLICK, bt2MouseClickHandler);
			function bt2MouseClickHandler():void
			{
				var window2:Panel = new Panel();
				window2.title = "Panel";
				window2.width = 500;
				window2.height = 300;
				popupManager.addPopUp(window2, false);
			}

			var bt3:Button = new Button();
			bt3.x = 300;
			bt3.label = "popup 3";
			componentContainer.addChild(bt3);
			bt3.addEventListener(MouseEvent.CLICK, bt3MouseClickHandler);
			function bt3MouseClickHandler():void
			{
				var window3:TitleWindow = new TitleWindow();
				window3.title = "TitleWindow2 Normal";
				window3.width = 500;
				window3.height = 300;
				
				popupManager.addPopUp(window3);
			}
			
			var bt4:Button = new Button();
			bt4.x = 400;
			bt4.label = "remove popup all";
			componentContainer.addChild(bt4);
			bt4.addEventListener(MouseEvent.CLICK, bt4MouseClickHandler);
			function bt4MouseClickHandler():void
			{
//				popupManager.removeAllPopUpChildren();
			}
			
			var bt6:Button = new Button();
			bt6.x = 400;
			bt6.label = "date chooese";
			componentContainer.addChild(bt6);
			bt6.addEventListener(MouseEvent.CLICK, bt6MouseClickHandler);
			function bt6MouseClickHandler():void
			{
				var d:DateChooser = new DateChooser();
				popupManager.addPopUp(d);
			}

			var bt5:Button = new Button();
			bt5.y = 30;
			bt5.label = "alert show";
			componentContainer.addChild(bt5);
			bt5.addEventListener(MouseEvent.CLICK, bt5MouseClickHandler);
			function bt5MouseClickHandler():void
			{
				for(var i:uint = 0; i < 1; i++)
				{
					var al:Alert = Alert.show("娱乐频道 >> 娱乐列表 " +
						">> 相声 \n" +
						"娱乐频道 >> 娱" +
						"乐列表 >>" +
						" 相声 >>小窗\n" +
						"娱乐频道 >> 娱乐列表 >> 相声 \n" +
						"娱乐频道 >> 娱乐列表 >> 相声 \n" +
						"娱乐频道 >> 娱乐列表 >> 相声 \n" +
						"娱乐频道 >> 娱乐列表 >> 相声 \n" +
						"娱乐频道 >> 娱乐列表 >> 相声 \n" +
						"娱乐频道 >> 娱乐列表 >> 相声 列表 >> 相声 ", "关灯开灯", 
						application, 
						Alert.OK | Alert.CANCEL,
//						Alert.OK,
						null, AssetsReference.assets3); 
					al.icon = AssetsReference.assets5;
					
					al.validateNow();
//					trace(al.width, al.height);
				}
			}
			
			var menu:Menu;
			var bt7:Button = new Button();
			bt7.label = "Menu";
			componentContainer.addChild(bt7);
			bt7.addEventListener(MouseEvent.CLICK, function bt6MouseClickHandler():void
			{
				if(menu == null)
				{
					var xml:XML = <root label="I'm root xml">
									<menuitem label="MenuItem B" type="check" toggled="true"/>
									<menuitem label="MenuItem C" type="check" toggled="false"/>
									<menuitem type="separator"/>
									<menuitem label="MenuItem D" >
										<menuitem label="SubMenuItem D-1" type="radio" groupName="one">
											<menuitem label="SubMenuItem F-1" type="radio" groupName="one">
												<menuitem label="SubMenuItem G-1" type="radio" groupName="one"/>
												<menuitem label="SubMenuItem G-2" type="radio" groupName="one" toggled="true"/>
												<menuitem label="SubMenuItem G-3" type="radio" groupName="one"/>
											</menuitem>
											<menuitem label="SubMenuItem F-2" type="radio" groupName="one" toggled="true"/>
											<menuitem label="SubMenuItem F-3" type="radio" groupName="one"/>
										</menuitem>
										<menuitem label="SubMenuItem D-2" type="radio" groupName="one" toggled="true"/>
										<menuitem label="SubMenuItem D-3" type="radio" groupName="one"/>
									</menuitem>
									<menuitem type="separator"/>
									<menuitem label="MenuItem E" >
										<menuitem label="SubMenuItem E-1" type="radio" groupName="one"/>
										<menuitem label="SubMenuItem E-2" type="radio" groupName="one" toggled="true"/>
										<menuitem label="SubMenuItem E-3" type="radio" groupName="one"/>
									</menuitem>
								</root>;
					
					var list:IList = new TreeList(xml.elements());
					menu = Menu.createMenu(list, application);
				}
				
				menu.showXY(20 , 30);
			});
		}
	}
}