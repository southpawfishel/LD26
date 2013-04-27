package
{
    import UI.View;
    
    import cocos2d.CCNode;
    
    import Loom.GameFramework.LoomGroup;
    
    public class GameView extends View
    {
        public var group:LoomGroup;
        
        private var _level:GameLevel;
        
        public function GameView()
        {
            super();
        }
        
        public function enter(parent:CCNode)
        {
            super.enter(parent);
        
            if (!_level)
            {
                _level = new GameLevel();
                _level.owningGroup = group;
                _level.initialize("level");
            }
        }
        
        public function exit()
        {
            if (_level)
            {
                _level.destroy();
                _level = null;
            }
        
            super.exit();
        }
    }
}