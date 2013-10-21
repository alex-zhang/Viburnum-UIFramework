package com.viburnum.components
{
    import com.viburnum.components.baseClasses.TextBase;

//    Label 控件显示一行不可编辑的文本
    public class Label extends TextBase
    {
        public function Label()
        {
            super();
			
			selectable = false;
        }
    }
}