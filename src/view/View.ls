package UI
{
    import cocos2d.CCNode;

    public delegate ViewCallback():void;

    /**
     * Base view class; convenience callbacks to trigger transitions and 
     * sequence adding/removing from parent.
     */
    class View extends CCNode
    {
        public var onEnter:ViewCallback;
        public var onExit:ViewCallback;

        public function enter(parent:CCNode):void
        {
            parent.addChild(this);
            onEnter();
        }

        public function exit():void
        {
            if(getParent())
            {
                getParent().removeChild(this);
                onExit();
            }
        }

    }
}