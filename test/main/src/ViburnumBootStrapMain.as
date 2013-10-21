package
{
	import cases.BitmapImageTest;
	import cases.ButtonControlTest;
	import cases.CollectionTest;
	import cases.DataChooserTest;
	import cases.DataGroupTest;
	import cases.DropDownListTest;
	import cases.H2VDividedContainerTest;
	import cases.LayoutTest;
	import cases.ListTest;
	import cases.MutiSelectableViewPageTest;
	import cases.OthersControlTest;
	import cases.PopupManagerTest;
	import cases.ScrollerTest;
	import cases.SystemStageBonusTest;
	import cases.TextTest;
	import cases.ToolTipTest;
	
	import com.viburnum.components.Application;
	import com.viburnum.components.BorderContainer;
	import com.viburnum.components.Button;
	import com.viburnum.components.HDividedContainer;
	import com.viburnum.components.SkinableComponent;
	import com.viburnum.components.TitleWindow;
	import com.viburnum.core.PositionConstrainType;
	import com.viburnum.layouts.HorizontalLayout;
	import com.viburnum.layouts.VerticalLayout;
	import com.viburnum.skins.ProgrammaticSkin;
	import com.viburnum.utils.TimeRecordUtil;
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	import mx.utils.NameUtil;
	
	public class ViburnumBootStrapMain extends Application
	{
		private static var instance:ViburnumBootStrapMain;
		
		public static function getInstance():ViburnumBootStrapMain
		{
			return instance;
		}
		
		private var leftListContainer:BorderContainer;
		private var rightShowContainer:BorderContainer;
		
		public function ViburnumBootStrapMain()
		{
			super();
			
			TimeRecordUtil.recordCurrentRunTime(this.name);
			
			//-------------
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.paddingTop = 20;
			layout.paddingBottom = 20;
			layout.paddingLeft = 20;
			layout.paddingRight = 20;
			
			contentGroup.layout = layout;
			
			instance = this;
		}

		override protected function onCreateComplete():void
		{
			super.onCreateComplete();
			
			trace(this, "initializedComplete time", TimeRecordUtil.getRecordedTotalRunTime(this.name));
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
//			var window3:TitleWindow = new TitleWindow();
//			//				window3.icon = AssetsReference.assets5;
//			window3.setStyle("titleIcon", AssetsReference.assets3);
//			window3.allowCloseWhenPopup = true;
//			window3.title = "Title Window1 isAlwaysPopupCenter true";
////			window3.width = 500;
////			window3.height = 300;
//			
//			popupManager.addPopUp(window3, false);
//			
//			popupManager.constrainPostion(window3, PositionConstrainType.CENTER, true);
//			
			
			//			var me:MenuItemRenderer = new MenuItemRenderer();
			//			me.addEventListener(MouseEvent.CLICK, function ():void {me.selected = !me.selected});
			////			me.enabled = false;
			//			me.type = MenuItemType.SEPARATOR;
			//			me.selected = true;
			//			me.hasChildren = true;
			//			me.label = "I'm a MenuItemRenderer";
			//			addChild(me);
			
			//			var me:Menu = Menu.createMenu(null ,this);
			//			me.show(20, 20);
			//			
			//			var b:Button = new Button();
			//			b.label = "hello --   ' ";
			//			addContentChild(b);
			//			return;
			
			var hdivider:HDividedContainer = new HDividedContainer();
			hdivider.setStyle("backgroundSkin", null);
			hdivider.percentWidth = 1;
			hdivider.percentHeight = 1;
			addContentChild(hdivider);
			
			leftListContainer = new BorderContainer();
			leftListContainer.setStyle("backgroundSkin_backgroundColor", 0x111111);
			leftListContainer.setStyle("backgroundSkin_backgroundAlpha", 0.3);
			leftListContainer.percentWidth = 0.3;
			leftListContainer.percentHeight = 1;
			
			rightShowContainer = new BorderContainer();
			rightShowContainer.setStyle("backgroundSkin_backgroundColor", 0xeeeeee);
			rightShowContainer.setStyle("backgroundSkin_backgroundAlpha", 0.3);
			rightShowContainer.percentWidth = 1;
			rightShowContainer.percentHeight = 1;
			hdivider.addViewPage(leftListContainer);
			hdivider.addViewPage(rightShowContainer);

			var verticalLayoutl:VerticalLayout = new VerticalLayout();
			leftListContainer.contentLayout = verticalLayoutl;

			var verticalLayoutr:VerticalLayout = new VerticalLayout();
			rightShowContainer.contentLayout = verticalLayoutr;

			initTestClassInstances();
		}
		
		override protected function onDetachToDisplayList():void
		{
			super.onDetachToDisplayList();
			
			instance = null;
		}
		
		private function getTestClasses():Array
		{
			return [
				BitmapImageTest,
				ButtonControlTest,
				SystemStageBonusTest,
				DataChooserTest,
				DataGroupTest,
				H2VDividedContainerTest,
				OthersControlTest,
				PopupManagerTest,
				ScrollerTest,
				TextTest,
				ToolTipTest,
				LayoutTest,
				MutiSelectableViewPageTest,
				DropDownListTest,
				ListTest,
				CollectionTest
			];
		}
		
		private function initTestClassInstances():void
		{
			var clses:Array = getTestClasses();
			clses.sort(sortFunc);
			
			function sortFunc(a:Class, b:Class):Number
			{
				var astr:String = NameUtil.getUnqualifiedClassName(a).charAt(0).toLowerCase();
				var bs:String = NameUtil.getUnqualifiedClassName(b).charAt(0).toLowerCase();
				
				return astr.localeCompare(bs);
			}
			
			for each(var cls:Class in clses)
			{
				new cls();
			}
		}
		
		public function addTestListButon(button:Button):void
		{
			leftListContainer.addContentChild(button);
		}
		
		public function showTestView(instance:DisplayObject):void
		{
			clearTestView();
			
			rightShowContainer.addContentChild(instance);
		}
		
		private function clearTestView():void
		{
			rightShowContainer.removeAllContentChildren();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			//			trace(this, "measure", this.measuredWidth, this.measuredHeight);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			//			trace(this, "updateDisplayList", layoutWidth, layoutHeight);
		}
	}
}