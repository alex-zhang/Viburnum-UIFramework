package com.viburnum.components
{
    import com.viburnum.components.baseClasses.DividedContainerBase;

    public class VDividedContainer extends DividedContainerBase
    {
        public function VDividedContainer()
        {
            super();
			
			//defaut must be gap = 0
			myContentGroup = new VGroup();
			VGroup(myContentGroup).gap = 0;
        }
    }
}