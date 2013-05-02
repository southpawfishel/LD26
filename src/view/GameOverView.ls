package
{
    
    import Loom.Animation.Tween;
    import Loom.Animation.EaseType;
    import Loom.LML.LML;
    import Loom.Platform.Timer;
    import Loom2D.Display.DisplayObjectContainer;
    import Loom2D.Display.Quad;
    import Loom2D.UI.Label;
    import UI.View;
    import UI.ViewCallback;
    
    public class GameOverView extends View
    {
        public var onReset:ViewCallback = new ViewCallback();
        public var onFadeIn:ViewCallback = new ViewCallback();
        
        protected var _gameOver:Label;
        
        protected var _fadeToBlack:Quad = null;
        
        public function set alpha(value:Number)
        {
            if (_fadeToBlack)
            {
                _fadeToBlack.alpha = value;
            }
            if (_gameOver)
            {
                _gameOver.alpha = value;
            }
        }
        
        public function get alpha():int
        {
            if (_fadeToBlack)
            {
                return _fadeToBlack.alpha;
            }
        }
        
        public function GameOverView()
        {
            super();
        }
        
        public function enter(parent:DisplayObjectContainer)
        {
            super.enter(parent);
            
            var restartGameTimer:Timer = new Timer(3000);
            restartGameTimer.onComplete = onStartFadeOut;
            restartGameTimer.start();
            
            //_fadeToBlack = new Quad(5000, 5000, 0x000000);
            //_fadeToBlack.center = true;
            //_fadeToBlack.alpha = 0;
            //addChild(_fadeToBlack);
            
            _gameOver = new Label();
            _gameOver.fontFile = "assets/Curse-hd.fnt";
            _gameOver.text = "GAME OVER";
            _gameOver.scale = 0.5;
            _gameOver.x = 427; _gameOver.y = 320;
            _gameOver.alpha = 0;
            addChild(_gameOver);
            
            Tween.to(this, 0.5, { "opacity" : 255 }).onComplete = function(tween:Tween)
            {
                onFadeIn();
            }
            
            parent.setChildIndex(this, 100);
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