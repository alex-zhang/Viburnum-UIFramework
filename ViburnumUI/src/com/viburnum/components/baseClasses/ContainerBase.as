package com.viburnum.components.baseClasses
{
	import com.viburnum.components.IButton;
	import com.viburnum.components.SkinableComponent;
	import com.viburnum.layouts.LayoutBase;
	import com.viburnum.managers.IFocusManager;

	public class ContainerBase extends SkinableComponent
    {
		protected var myContentGroup:GroupBase;

		private var _focusManager:IFocusManager;
		private var _defaultButton:IButton;

		private var _icon:Class;
		private var _iconChangedFlag:Boolean = false;
		
		private var _title:String;
		private var _titleChangedFlag:Boolean = false;

        public function ContainerBase()
        {
            super();
        }
		
		public function get icon():Class
		{
			return _icon;
		}
		
		[Inspectable(type="Class")]
		public function set icon(value:Class):void
		{
			if(_icon != value)
			{
				_icon = value;

				_iconChangedFlag = true;
				invalidateProperties();
			}
		}
		
		public function get title():String
		{
			return _title;
		}
		
		[Inspectable(type="String")]
		public function set title(value:String):void
		{
			if(_title != value)
			{
				_title = value;
				
				_titleChangedFlag = true;
				invalidateProperties();
			}
		}
		
		private var _preAddedChildren:Array;
		override protected function delwithChildrenInConstractor():void
		{
			_preAddedChildren = [];
			
			for(var i:int = 0, n:int = super.numChildren; i < n; i++)
			{
				_preAddedChildren.push(super.getChildAt(i));
			}
			
			super.delwithChildrenInConstractor();
		}

		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myContentGroup.name = "contentgroup";
			
			while(_preAddedChildren.length)
			{
				myContentGroup.addChild(_preAddedChildren.shift());
			}
			
			addChild(myContentGroup);
		}
		
		public function get contentLayout():LayoutBase
		{
			return myContentGroup.layout;
		}

		public function set contentLayout(value:LayoutBase):void
		{
			myContentGroup.layout = value;
		}
		
		//IFocusManagerContainer Interface==================================
		override public function get focusManager():IFocusManager
		{
			return _focusManager == null ? super.focusManager : _focusManager;
		}

		public function set focusManager(value:IFocusManager):void
		{
			_focusManager = value;
		}

		public function get defaultButton():IButton
		{
			return _defaultButton;	
		}

		public function set defaultButton(value:IButton):void
		{
			_defaultButton = value;
		}
		
		override protected function onValidateProperties():void
		{
			super.onValidateProperties();
			
			if(_iconChangedFlag)
			{
				_iconChangedFlag = false;
				
				iconChanged();
			}
			
			if(_titleChangedFlag)
			{
				_titleChangedFlag = false;
				
				titleChanged();
			}
		}
		
		protected function iconChanged():void
		{
		}
		
		protected function titleChanged():void
		{
		}
    }
}