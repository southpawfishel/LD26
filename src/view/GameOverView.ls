package
{
    
	import Loom.Animation.Tween;
	import Loom.Platform.Timer;
	import Loom2D.Display.DisplayObjectContainer;
	import Loom2D.Display.Image;
	import Loom2D.Display.Quad;
	import Loom2D.Display.Stage;
    import Loom2D.Loom2D;
	import Loom2D.Textures.Texture;
	import Loom2D.UI.Label;
	import UI.View;
	import UI.ViewCallback;
    
    public class GameOverView extends View
    {
        public var onReset:ViewCallback = new ViewCallback();
        public var onFadeIn:ViewCallback = new ViewCallback();
        
        protected var _gameOver:Label;
        
        protected var _fadeToBlack:Quad = null;
		protected var _tempBG:Image = null;
        
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
            
            _fadeToBlack = new Quad(Loom2D.stage.stageWidth, Loom2D.stage.stageHeight, 0x000000);
            _fadeToBlack.center = true;
            _fadeToBlack.alpha = 0;
            addChild(_fadeToBlack);
            
            _gameOver = new Label();
            _gameOver.fontFile = "assets/Curse-hd.fnt";
            _gameOver.text = "GAME OVER";
            _gameOver.x = Loom2D.stage.stageWidth / 2;
            _gameOver.y = Loom2D.stage.stageHeight / 2;
            _gameOver.pivotX = _gameOver.width / 2;
            _gameOver.pivotY = _gameOver.height / 2;
            _gameOver.scale = 0.5;
            _gameOver.alpha = 0;
            addChild(_gameOver);
            
            Tween.to(this, 0.5, { "alpha" : 1 }).onComplete = function(tween:Tween)
            {
                onFadeIn();
            }
            
            parent.setChildIndex(this, 100);
        }
        
        public function exit()
        {
            Tween.to(this, 0.5, { "alpha" : 0 }).onComplete = onFadeFinished;
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