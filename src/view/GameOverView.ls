package
{
    import UI.View;
    import UI.ViewCallback;
    import UI.Label;
    
    import Loom.Animation.Tween;
    import Loom.Animation.EaseType;
    import Loom.LML.LML;
    
    import Loom.Platform.Timer;
    
    import cocos2d.CCNode;
    import cocos2d.CCPoint;
    import cocos2d.CCScaledLayer;
    import cocos2d.CCUserDefault;
    import cocos2d.CCLayerColor;
    import cocos2d.ccColor4B;
    
    public class GameOverView extends View
    {
        public var onReset:ViewCallback = new ViewCallback();
        public var onFadeIn:ViewCallback = new ViewCallback();
        
        protected var _gameOver:Label;
        
        protected var _fadeToBlack:CCLayerColor = null;
        
        public function set opacity(value:int)
        {
            if (_fadeToBlack)
            {
                _fadeToBlack.setOpacity(value);
            }
            if (_gameOver)
            {
                _gameOver.setOpacity(value);
            }
        }
        
        public function get opacity():int
        {
            if (_fadeToBlack)
            {
                return _fadeToBlack.getOpacity();
            }
        }
        
        public function GameOverView()
        {
            super();
        }
        
        public function enter(parent:CCNode)
        {
            super.enter(parent);
            
            var restartGameTimer:Timer = new Timer(3000);
            restartGameTimer.onComplete = onStartFadeOut;
            restartGameTimer.start();
            
            var black:ccColor4B = new ccColor4B();
            black.r = 0; black.g = 0; black.b = 0; black.a = 255;
            _fadeToBlack = CCLayerColor.create(black, 5000, 5000);
            _fadeToBlack.setOpacity(0);
            addChild(_fadeToBlack);
            
            _gameOver = new Label("assets/Curse-hd.fnt");
            _gameOver.text = "GAME OVER";
            _gameOver.scale = 0.5;
            _gameOver.setPosition(427, 320);
            _gameOver.setOpacity(0);
            addChild(_gameOver);
            
            Tween.to(this, 0.5, { "opacity" : 255 }).onComplete = function(tween:Tween)
            {
                onFadeIn();
            }
            
            parent.reorderChild(this, 100);
        }
        
        public function exit()
        {
            Tween.to(this, 0.5, { "opacity" : 0 }).onComplete = onFadeFinished;
        }
        
        public function onStartFadeOut(timer:Timer):void
        {
            onReset();
            exit();
        }

        public function onFadeFinished(tween:Tween):void
        {
            removeChild(_fadeToBlack, true);
            _fadeToBlack = null;
            
            removeChild(_gameOver, true);
            _gameOver = null;
            
            super.exit();
        }
    }
}