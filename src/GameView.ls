package
{
    import UI.View;
    
    import cocos2d.CCNode;
    
    import Loom.GameFramework.LoomGroup;
    
    public class GameView extends View
    {
        public var group:LoomGroup;
        
        private var _level:GameLevel;
        private var _hud:HUDView;
        
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
            
            if (!_hud)
            {
                _hud = new HUDView();
                _level.onGameStart += _hud.onGameStart;
                _level.onTimeChanged += _hud.onTimeChanged;
                _level.onPolarityChanged += _hud.onPolarityChanged;
                _level.onHealthChanged += _hud.onHealthChanged;
                _level.onGameOver += _hud.onGameOver;
                
                _hud.onReset += onReset;
                
                _hud.enter(parent);
            }
        }
        
        public function exit()
        {
            if (!_hud)
            {
                _level.onGameStart -= _hud.onGameStart;
                _level.onTimeChanged -= _hud.onTimeChanged;
                _level.onPolarityChanged -= _hud.onPolarityChanged;
                _level.onHealthChanged -= _hud.onHealthChanged;
                _level.onGameOver -= _hud.onGameOver;
                
                _hud.onReset -= onReset;
                
                _hud.exit();
                _hud = null;
            }
            
            if (_level)
            {
                _level.destroy();
                _level = null;
            }
        
            super.exit();
        }
        
        public function onReset()
        {
            _level.destroy();
            _level = new GameLevel();
            _level.owningGroup = group;
            _level.initialize("level");
        }
    }
}