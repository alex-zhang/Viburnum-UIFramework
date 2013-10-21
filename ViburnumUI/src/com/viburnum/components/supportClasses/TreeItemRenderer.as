package com.viburnum.components.supportClasses
{
	import com.viburnum.components.ItemRender;
	import com.viburnum.components.Label;
	import com.viburnum.components.StateName;
	import com.viburnum.components.Tree;
	import com.viburnum.data.IHiberarchyNode;
	import com.viburnum.components.ITreeItemRenderer;
	import com.viburnum.skins.IHiberarchyRelationWireSkin;
	import com.viburnum.utils.LayoutUtil;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	[Style(name="leafIconSkin", type="Class", skinClass="true")]

	[Style(name="branchIconSkin", type="Class", skinClass="true")]
	[Style(name="branchIconSkin_closedSkin", type="Class")]
	[Style(name="branchIconSkin_openedSkin", type="Class")]
	
	[Style(name="folderIconSkinWidth", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	[Style(name="folderIconSkinHeight", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	
	[Style(name="folderIconSkin", type="Class", skinClass="true")]
	[Style(name="folderIconSkin_closedSkin", type="Class")]
	[Style(name="folderIconSkin_openedSkin", type="Class")]
	
	[Style(name="isUseRelationWire", type="Boolean", invalidateDisplayList="true")]
	[Style(name="treeRelationWireSkin", type="Class", skinClass="true", isDynamic="true")]
	[Style(name="treeRelationWireSkin_color", type="uint", format="Color")]

	[Style(name="itemGap", type="Number", invalidateSize="true", invalidateDisplayList="true")]
	
	public class TreeItemRenderer extends ItemRender implements ITreeItemRenderer
	{
		private static const DEFAULT_FOLDER_ICON_SIZE:Number = 16;
		
		public var branchIconSkin:DisplayObject;
		public var leafIconSkin:DisplayObject;
		public var folderIconSkin:DisplayObject;
		public var treeRelationWireSkin:DisplayObject;

		protected var lableTextField:Label;
		
		private var _hasBranch:Boolean = false;
		
		private var _customLeafIcon:Class;
		private var _leafeIconChangedFlag:Boolean = false;
		
		private var _customFolderIcon:Class;
		private var _folderIconChangedFlag:Boolean = false;
		
		private var _treeOwner:Tree;
		
		private var _isopen:Boolean = false;
		
		private var _depth:uint = 0;

		public function TreeItemRenderer()
		{
			super();
		}
		
		public function get hasBranch():Boolean
		{
			return _hasBranch;
		}
		
		public function set hasBranch(value:Boolean):void
		{
			_hasBranch = value;
		}
		
		public function get leafIcon():Class
		{
			return _customLeafIcon;
		}

		public function set leafIcon(value:Class):void
		{
			_customLeafIcon = value;
			_leafeIconChangedFlag = true;
			invalidateProperties();
		}

		public function get folderIcon():Class
		{
			return _customLeafIcon;
		}

		public function set folderIcon(value:Class):void
		{
			_customLeafIcon = value;
			_folderIconChangedFlag = true;
			invalidateProperties();
		}
		
		public function get treeOwner():Tree
		{
			return _treeOwner;
		}
		
		public function set treeOwner(value:Tree):void
		{
			_treeOwner = value;
		}
		
		public function get isOpen():Boolean
		{
			return _isopen;
		}
		
		public function set isOpen(value:Boolean):void
		{
			if(_isopen != value)
			{
				_isopen = value;
				
				currentState = getCurrentSkinState();
				
				invalidateDisplayList();
			}
		}
		
		public function get depth():uint
		{
			return _depth;
		}
		
		public function set depth(value:uint):void
		{
			if(_depth != value)
			{
				_depth = value;
				
				invalidateSize();
				invalidateDisplayList();
			}
		}
		
		override public function notifyStyleChanged(styleProp:String):void
		{
			if(styleProp == "isUseRelationWire")
			{
				if(getStyle("isUseRelationWire"))
				{
					generateValidDynamicSkinPartNow("treeRelationWireSkin");
				}
				else
				{
					destoryValidDynamicSkinPartNow("treeRelationWireSkin");
				}
			}
			
			super.notifyStyleChanged(styleProp);
		}
		
		override protected function getCurrentSkinState():String//up over down disable
		{
			var skinState:String = super.getCurrentSkinState();
			
			if(_isopen)
			{
				return "opened_" + skinState;
			}
			
			return skinState;
		}
		
		override protected function skinStateChanged(skinPartName:String, skin:DisplayObject, skinState:String):void
		{
			if(skinPartName == "leafIconSkin") return;//leafIconSkin不参与状态改变
			
			//这两个皮肤只关心两个状态
			if(skinPartName == "branchIconSkin" || skinPartName == "folderIconSkin")
			{
				if(_isopen)
				{
					super.skinStateChanged(skinPartName, skin, StateName.OPENED);
				}
				else
				{
					super.skinStateChanged(skinPartName, skin, StateName.CLOSED);
				}
			}
			else
			{
				//其他的皮肤过滤掉opened_状态
				if(_isopen)
				{
					skinState = skinState.replace("opened_", "");
				}
				
				super.skinStateChanged(skinPartName, skin, skinState);
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			lableTextField = new Label();
			addChild(lableTextField);
		}
		
		override protected function updateAllSkinPartsVisualState():void
		{
			LayoutUtil.setDisplayObjectVisiable(branchIconSkin, _hasBranch);
			LayoutUtil.setDisplayObjectVisiable(folderIconSkin, _hasBranch);
			LayoutUtil.setDisplayObjectVisiable(leafIconSkin, !_hasBranch);
			
			LayoutUtil.sortDisplayObjectChildren(this, treeRelationWireSkin, backgroundSkin);
		}
		
		override protected function onSkinPartAttachToDisplayList(skinPartName:String, skin:DisplayObject):void
		{
			if(branchIconSkin != null)
			{
				IEventDispatcher(branchIconSkin).addEventListener(MouseEvent.MOUSE_DOWN, branchIconSkinMouseDownHandler, false, 0 ,true);
			}
		}
		
		override protected function onSkinPartDetachFromDisplayList(skinPartName:String, skin:DisplayObject):void
		{
			if(skinPartName == "branchIconSkin")
			{
				if(branchIconSkin != null)
				{
					IEventDispatcher(branchIconSkin).removeEventListener(MouseEvent.MOUSE_DOWN, branchIconSkinMouseDownHandler);
				}
			}
		}
		
		private function branchIconSkinMouseDownHandler(event:MouseEvent):void
		{
			if(_treeOwner != null && _hasBranch)
			{
				_treeOwner.expandItem(this.data, !isOpen);
			}
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_folderIconChangedFlag)
			{
				_folderIconChangedFlag = false;
				
				updateValidStaticSkinPartNow("folderIconSkin", _customFolderIcon);
			}

			if(_leafeIconChangedFlag)
			{
				_leafeIconChangedFlag = false;
				
				updateValidStaticSkinPartNow("leafIconSkin", _customLeafIcon);
			}
		}
		
		override protected function dataChanged():void
		{
			super.dataChanged();

			lableTextField.text = this.label;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var itemGap:Number = getDefaultStyle("itemGap", 2);
			
			var branchIconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(branchIconSkin);
			var branchIconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(branchIconSkin);
			
			var folderIconSkinMW:Number = getDefaultStyle("folderIconSkinWidth", DEFAULT_FOLDER_ICON_SIZE);
			var folderIconSkinMH:Number = getDefaultStyle("folderIconSkinHeight", DEFAULT_FOLDER_ICON_SIZE);
			
			var leafIconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(leafIconSkin);
			var labelMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(lableTextField);
			
			var depthPadding:Number = (branchIconSkinMW + itemGap + (folderIconSkinMW - branchIconSkinMW) / 2) * _depth;
			
			var measuredW:Number = depthPadding + branchIconSkinMW;

			if(_hasBranch)
			{
				measuredW += folderIconSkinMW;
			}
			else
			{
				var leafIconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(folderIconSkin);
				measuredW += leafIconSkinMW;
			}
			
			var labelMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(lableTextField);
			measuredW += labelMW + itemGap * 2;
			
			var measuredH:Number = Math.max(branchIconSkinMH, folderIconSkinMH, leafIconSkinMH, labelMH);
			
			setMeasuredSize(measuredW, measuredH);
		}
		
		override protected function updateDisplayList(layoutWidth:Number, layoutHeight:Number):void
		{
			super.updateDisplayList(layoutWidth, layoutHeight);
			
			//
			var itemGap:Number = getDefaultStyle("itemGap", 2);
			
			var branchIconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(branchIconSkin);
			var branchIconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(branchIconSkin);
			
			var folderIconSkinMW:Number = getDefaultStyle("folderIconSkinWidth", DEFAULT_FOLDER_ICON_SIZE);
			var folderIconSkinMH:Number = getDefaultStyle("folderIconSkinHeight", DEFAULT_FOLDER_ICON_SIZE);
			
			var leafIconSkinMW:Number = LayoutUtil.getDisplayObjectMeasuredWidth(leafIconSkin);
			var leafIconSkinMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(leafIconSkin);
			
			if(treeRelationWireSkin is IHiberarchyRelationWireSkin)
			{
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setDepth(_depth);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setBranchSize(branchIconSkinMW, branchIconSkinMH);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setFolderSize(folderIconSkinMW, folderIconSkinMH);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setLeafSize(leafIconSkinMW, leafIconSkinMH);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setItemGap(itemGap);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).hasBranch(_hasBranch);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setIsOpen(_isopen);
				IHiberarchyRelationWireSkin(treeRelationWireSkin).setNode(data as IHiberarchyNode);
				
				LayoutUtil.setDisplayObjectSize(treeRelationWireSkin, layoutWidth, layoutHeight);
			}
			
			//
			var labelMH:Number = LayoutUtil.getDisplayObjectMeasuredHeight(lableTextField);
			
			var depthPadding:Number = (branchIconSkinMW + itemGap + (folderIconSkinMW - branchIconSkinMW) * 0.5) * _depth;
			
			var startX:Number = depthPadding;
			
			LayoutUtil.setDisplayObjectLayout(branchIconSkin, 
				startX, (layoutHeight - branchIconSkinMH) * 0.5, branchIconSkinMW, branchIconSkinMH);
			
			startX += branchIconSkinMW + itemGap;
			
			if(_hasBranch)
			{
				LayoutUtil.setDisplayObjectLayout(folderIconSkin, 
					startX, (layoutHeight - folderIconSkinMH) * 0.5, folderIconSkinMW, folderIconSkinMH);
				
				startX += folderIconSkinMW + itemGap;
			}
			else
			{
				LayoutUtil.setDisplayObjectLayout(leafIconSkin, 
					startX, (layoutHeight - leafIconSkinMH) * 0.5, leafIconSkinMW, leafIconSkinMH);
				
				startX += leafIconSkinMW + itemGap;
			}
			
			LayoutUtil.setDisplayObjectLayout(lableTextField, 
				startX, (layoutHeight - labelMH) * 0.5, layoutWidth - startX, labelMH);
		}
	}
}