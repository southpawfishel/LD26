package
{
    import Loom2D.Display.DisplayObjectContainer;
    import UI.View;
    
    import Loom.GameFramework.LoomGroup;
    
    public class GameView extends View
    {
        private var _level:GameLevel;
        
        public function get level():GameLevel
        {
            return _level;
        }
        
        public function GameView()
        {
            super();
        }
        
        public function enter(parent:DisplayObjectContainer)
        {
            super.enter(parent);
        
            if (!_level)
            {
                _level = new GameLevel();
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