package com.viburnum.components
{
	import com.viburnum.components.baseClasses.SkinnableContainerBase;
	
	import flash.display.DisplayObject;

    public class SkinableContainer extends SkinnableContainerBase implements IFocusManagerContainer
    {
        public function SkinableContainer()
        {
            super();

			//defaut
			myContentGroup = new Group();
        }

		public function getContentAllChildren():Array
		{
			return Group(myContentGroup).getAllChildren();
		}
		
		public function removeAllContentChildren():void
		{
			Group(myContentGroup).removeChildren();
		}
		
		public function get numContentChildren():int
		{
			return myContentGroup.numChildren;
		}
		
		public function addContentChild(child:DisplayObject):DisplayObject
		{
			return myContentGroup.addChild(child);
		}
		
		public function addContentChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return myContentGroup.addChildAt(child, index);
		}
		
		public function removeContentChild(child:DisplayObject):DisplayObject
		{
			return myContentGroup.removeChild(child);
		}
		
		public function removeContentChildAt(index:int):DisplayObject
		{
			return myContentGroup.removeChildAt(index);
		}
		
		public function getContentChildAt(index:int):DisplayObject
		{
			return myContentGroup.getChildAt(index);
		}
		
		public function getContentChildByName(name:String):DisplayObject
		{
			return myContentGroup.getChildByName(name);
		}
		
		public function setContentChildIndext(child:DisplayObject, index:int):void
		{
			myContentGroup.setChildIndex(child, index);
		}
		
		public function swapContentChildrenAt(index1:int, index2:int):void
		{
			myContentGroup.swapChildrenAt(index1, index2);
		}
		
		public function swapContentChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			myContentGroup.swapChildren(child1, child2);
		}
    }
}