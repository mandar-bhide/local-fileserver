import 'package:flutter/widgets.dart';

const _r = 0xE001;
const _apple = 0xE002;
const _argdown = 0xE003;
const _asm = 0xE004;
const _audio = 0xE005;
const _babel = 0xE006;
const _bower = 0xE007;
const _bsl = 0xE008;
const _c_sharp = 0xE009;
const _c = 0xE00A;
const _cake = 0xE00B;
const _cake_php = 0xE00C;
const _checkbox_unchecked = 0xE00D;
const _checkbox = 0xE00E;
const _cjsx = 0xE00F;
const _clock = 0xE010;
const _clojure = 0xE011;
const _code_climate = 0xE012;
const _code_search = 0xE013;
const _coffee = 0xE014;
const _coffee_erb = 0xE015;
const _coldfusion = 0xE016;
const _config = 0xE017;
const _cpp = 0xE018;
const _crystal = 0xE019;
const _crystal_embedded = 0xE01A;
const _css = 0xE01B;
const _csv = 0xE01C;
const _d = 0xE01D;
const _dart = 0xE01E;
const _db = 0xE01F;
const _default = 0xE020;
const _deprecation_cop = 0xE021;
const _docker = 0xE022;
const _editorconfig = 0xE023;
const _ejs = 0xE024;
const _elixir = 0xE025;
const _elixir_script = 0xE026;
const _elm = 0xE027;
const _error = 0xE028;
const _eslint = 0xE029;
const _ethereum = 0xE02A;
const _f_sharp = 0xE02B;
const _favicon = 0xE02C;
const _firebase = 0xE02D;
const _firefox = 0xE02E;
const _folder = 0xE02F;
const _font = 0xE030;
const _git = 0xE031;
const _git_folder = 0xE032;
const _git_ignore = 0xE033;
const _github = 0xE034;
const _go = 0xE035;
const _go2 = 0xE036;
const _gradle = 0xE037;
const _grails = 0xE038;
const _graphql = 0xE039;
const _grunt = 0xE03A;
const _gulp = 0xE03B;
const _hacklang = 0xE03C;
const _haml = 0xE03D;
const _happenings = 0xE03E;
const _haskell = 0xE03F;
const _haxe = 0xE040;
const _heroku = 0xE041;
const _hex = 0xE042;
const _html = 0xE043;
const _html_erb = 0xE044;
const _ignored = 0xE045;
const _illustrator = 0xE046;
const _image = 0xE047;
const _info = 0xE048;
const _ionic = 0xE049;
const _jade = 0xE04A;
const _java = 0xE04B;
const _javascript = 0xE04C;
const _jenkins = 0xE04D;
const _jinja = 0xE04E;
const _js_erb = 0xE04F;
const _json = 0xE050;
const _julia = 0xE051;
const _karma = 0xE052;
const _kotlin = 0xE053;
const _less = 0xE054;
const _license = 0xE055;
const _liquid = 0xE056;
const _livescript = 0xE057;
const _lock = 0xE058;
const _lua = 0xE059;
const _makefile = 0xE05A;
const _markdown = 0xE05B;
const _maven = 0xE05C;
const _mdo = 0xE05D;
const _mustache = 0xE05E;
const _new_file = 0xE05F;
const _npm = 0xE060;
const _npm_ignored = 0xE061;
const _nunjucks = 0xE062;
const _ocaml = 0xE063;
const _odata = 0xE064;
const _pddl = 0xE065;
const _pdf = 0xE066;
const _perl = 0xE067;
const _photoshop = 0xE068;
const _php = 0xE069;
const _plan = 0xE06A;
const _platformio = 0xE06B;
const _powershell = 0xE06C;
const _project = 0xE06D;
const _pug = 0xE06E;
const _puppet = 0xE06F;
const _python = 0xE070;
const _rails = 0xE071;
const _react = 0xE072;
const _reasonml = 0xE073;
const _rollup = 0xE074;
const _ruby = 0xE075;
const _rust = 0xE076;
const _salesforce = 0xE077;
const _sass = 0xE078;
const _sbt = 0xE079;
const _scala = 0xE07A;
const _search = 0xE07B;
const _settings = 0xE07C;
const _shell = 0xE07D;
const _slim = 0xE07E;
const _smarty = 0xE07F;
const _spring = 0xE080;
const _stylelint = 0xE081;
const _stylus = 0xE082;
const _sublime = 0xE083;
const _svg = 0xE084;
const _swift = 0xE085;
const _terraform = 0xE086;
const _tex = 0xE087;
const _time_cop = 0xE088;
const _todo = 0xE089;
const _tsconfig = 0xE08A;
const _twig = 0xE08B;
const _typescript = 0xE08C;
const _vala = 0xE08D;
const _video = 0xE08E;
const _vue = 0xE08F;
const _wasm = 0xE090;
const _wat = 0xE091;
const _webpack = 0xE092;
const _wgt = 0xE093;
const _windows = 0xE094;
const _word = 0xE095;
const _xls = 0xE096;
const _xml = 0xE097;
const _yarn = 0xE098;
const _yml = 0xE099;
const _zip = 0xE09A;
const _ignore= 0xff41535b;
const iconSetMap = {
  '.bsl': _bsl,
  '.mdo': _mdo,
  '.asm': _asm,
  '.s': _asm,
  '.c': _c,
  '.h': _c,
  '.m': _c,
  '.cs': _c_sharp,
  '.cshtml': _html,
  '.aspx': _html,
  '.ascx': _html,
  '.asax': _html,
  '.master': _html,
  '.cc': _cpp,
  '.cpp': _cpp,
  '.cxx': _cpp,
  '.hh': _cpp,
  '.hpp': _cpp,
  '.hxx': _cpp,
  '.mm': _cpp,
  '.clj': _clojure,
  '.cljs': _clojure,
  '.cljc': _clojure,
  '.edn': _clojure,
  '.cfc': _coldfusion,
  '.cfm': _coldfusion,
  '.coffee': _coffee,
  '.config': _config,
  '.cfg': _config,
  '.conf': _config,
  '.cr': _crystal,
  '.ecr': _crystal_embedded,
  '.slang': _crystal_embedded,
  '.cson': _json,
  '.css': _css,
  '.css.map': _css,
  '.sss': _css,
  '.csv': _csv,
  '.xls': _xls,
  '.xlsx': _xls,
  '.cake': _cake,
  '.ctp': _cake_php,
  '.d': _d,
  '.doc': _word,
  '.docx': _word,
  '.ejs': _ejs,
  '.ex': _elixir,
  '.exs': _elixir_script,
  'mix': _hex,
  '.elm': _elm,
  '.ico': _favicon,
  '.fs': _f_sharp,
  '.fsx': _f_sharp,
  '.gitignore': _git,
  '.gitconfig': _git,
  '.gitkeep': _git,
  '.gitattributes': _git,
  '.gitmodules': _git,
  '.go': _go2,
  '.slide': _go,
  '.article': _go,
  '.gradle': _gradle,
  '.groovy': _grails,
  '.gsp': _grails,
  '.gql': _graphql,
  '.graphql': _graphql,
  '.haml': _haml,
  '.handlebars': _mustache,
  '.hbs': _mustache,
  '.hjs': _mustache,
  '.hs': _haskell,
  '.lhs': _haskell,
  '.hx': _haxe,
  '.hxs': _haxe,
  '.hxp': _haxe,
  '.hxml': _haxe,
  '.html': _html,
  '.jade': _jade,
  '.java': _java,
  '.class': _java,
  '.classpath': _java,
  '.properties': _java,
  '.js': _javascript,
  '.js.map': _javascript,
  '.spec.js': _javascript,
  '.test.js': _javascript,
  '.es': _javascript,
  '.es5': _javascript,
  '.es6': _javascript,
  '.es7': _javascript,
  '.jinja': _jinja,
  '.jinja2': _jinja,
  '.json': _json,
  '.jl': _julia,
  'karma.conf.js': _karma,
  'karma.conf.coffee': _karma,
  '.kt': _kotlin,
  '.kts': _kotlin,
  '.dart': _dart,
  '.less': _less,
  '.liquid': _liquid,
  '.ls': _livescript,
  '.lua': _lua,
  '.markdown': _markdown,
  '.md': _markdown,
  '.argdown': _argdown,
  '.ad': _argdown,
  'readme.md': _info,
  'changelog.md': _clock,
  'changelog': _clock,
  'changes.md': _clock,
  'version.md': _clock,
  'version': _clock,
  'mvnw': _maven,
  '.mustache': _mustache,
  '.stache': _mustache,
  '.njk': _nunjucks,
  '.nunjucks': _nunjucks,
  '.nunjs': _nunjucks,
  '.nunj': _nunjucks,
  '.njs': _nunjucks,
  '.nj': _nunjucks,
  '.npm-debug.log': _npm,
  '.npmignore': _npm,
  '.npmrc': _npm,
  '.ml': _ocaml,
  '.mli': _ocaml,
  '.cmx': _ocaml,
  '.cmxa': _ocaml,
  '.odata': _odata,
  '.pl': _perl,
  '.php': _php,
  '.php.inc': _php,
  '.pddl': _pddl,
  '.plan': _plan,
  '.happenings': _happenings,
  '.ps1': _powershell,
  '.psd1': _powershell,
  '.psm1': _powershell,
  '.pug': _pug,
  '.pp': _puppet,
  '.epp': _puppet,
  '.py': _python,
  '.jsx': _react,
  '.spec.jsx': _react,
  '.test.jsx': _react,
  '.cjsx': _react,
  '.tsx': _react,
  '.spec.tsx': _react,
  '.test.tsx': _react,
  '.re': _reasonml,
  '.r': _r,
  '.rb': _ruby,
  '.erb': _html_erb,
  '.erb.html': _html_erb,
  '.html.erb': _html_erb,
  '.rs': _rust,
  '.sass': _sass,
  '.scss': _sass,
  '.springbeans': _spring,
  '.slim': _slim,
  '.smarty.tpl': _smarty,
  '.sbt': _sbt,
  '.scala': _scala,
  '.sol': _ethereum,
  '.styl': _stylus,
  '.swift': _swift,
  '.sql': _db,
  '.tf': _terraform,
  '.tf.json': _terraform,
  '.tfvars': _terraform,
  '.tex': _tex,
  '.sty': _tex,
  '.dtx': _tex,
  '.ins': _tex,
  '.txt': _default,
  '.toml': _config,
  '.twig': _twig,
  '.ts': _typescript,
  '.spec.ts': _typescript,
  '.test.ts': _typescript,
  'tsconfig.json': _tsconfig,
  '.vala': _vala,
  '.vapi': _vala,
  '.vue': _vue,
  '.wasm': _wasm,
  '.wat': _wat,
  '.xml': _xml,
  '.yml': _yml,
  '.yaml': _yml,
  'swagger.json': _json,
  'swagger.yml': _json,
  'swagger.yaml': _json,
  '.jar': _zip,
  '.zip': _zip,
  '.wgt': _wgt,
  '.ai': _illustrator,
  '.psd': _photoshop,
  '.pdf': _pdf,
  '.eot': _font,
  '.ttf': _font,
  '.woff': _font,
  '.woff2': _font,
  '.gif': _image,
  '.jpg': _image,
  '.jpeg': _image,
  '.png': _image,
  '.pxm': _image,
  '.svg': _svg,
  '.svgx': _image,
  '.sublime-project': _sublime,
  '.sublime-workspace': _sublime,
  '.code-search': _code_search,
  '.component': _salesforce,
  '.cls': _salesforce,
  '.sh': _shell,
  '.zsh': _shell,
  '.fish': _shell,
  '.zshrc': _shell,
  '.bashrc': _shell,
  '.mov': _video,
  '.ogv': _video,
  '.webm': _video,
  '.avi': _video,
  '.mpg': _video,
  '.mp4': _video,
  '.mp3': _audio,
  '.ogg': _audio,
  '.wav': _audio,
  '.flac': _audio,
  '.3ds': _svg,
  '.3dm': _svg,
  '.stl': _svg,
  '.obj': _svg,
  '.dae': _svg,
  '.bat': _windows,
  '.cmd': _windows,
  'mime.types': _config,
  'jenkinsfile': _jenkins,
  '.babelrc': _babel,
  'bower.json': _bower,
  '.bowerrc': _bower,
  'dockerfile': _docker,
  '.dockerignore': _docker,
  'docker-healthcheck': _docker,
  'docker-compose.yml': _docker,
  'docker-compose.yaml': _docker,
  'docker-compose.override.yml': _docker,
  'docker-compose.override.yaml': _docker,
  '.codeclimate.yml': _code_climate,
  '.eslintrc': _eslint,
  '.eslintrc.js': _eslint,
  '.eslintrc.yaml': _eslint,
  '.eslintrc.yml': _eslint,
  '.eslintrc.json': _eslint,
  '.eslintignore': _eslint,
  '.firebaserc': _firebase,
  'firebase.json': _firebase,
  'geckodriver': _firefox,
  'gruntfile.js': _grunt,
  'gruntfile.babel.js': _grunt,
  'gruntfile.coffee': _grunt,
  'gulpfile': _gulp,
  'ionic.config.json': _ionic,
  'ionic.project': _ionic,
  '.jshintrc': _javascript,
  '.jscsrc': _javascript,
  'platformio.ini': _platformio,
  'rollup.config.js': _rollup,
  'sass-lint.yml': _sass,
  '.stylelintrc': _stylelint,
  '.stylelintrc.json': _stylelint,
  '.stylelintrc.yaml': _stylelint,
  '.stylelintrc.yml': _stylelint,
  '.stylelintrc.js': _stylelint,
  '.stylelintignore': _stylelint,
  'stylelint.config.js': _stylelint,
  'yarn.clean': _yarn,
  'yarn.lock': _yarn,
  'webpack.config.js': _webpack,
  'webpack.config.build.js': _webpack,
  'webpack.common.js': _webpack,
  'webpack.dev.js': _webpack,
  'webpack.prod.js': _webpack,
  '.direnv': _config,
  '.env': _config,
  '.static': _config,
  '.editorconfig': _config,
  '.slugignore': _config,
  '.tmp': _clock,
  '.htaccess': _config,
  '.key': _lock,
  '.cert': _lock,
  'license': _license,
  'licence': _license,
  'copying': _license,
  'compiling': _license,
  'contributing': _license,
  'makefile': _makefile,
  'qmakefile': _makefile,
  'omakefile': _makefile,
  'cmakelists.txt': _makefile,
  'procfile': _heroku,
  'todo': _todo,
  'npm-debug.log': _npm_ignored,
  '.ds_store':_ignored,
};

_getIconKey(String filename){
  String? key;
  filename = filename.toLowerCase();
  if (iconSetMap.containsKey(filename)) {
    key = filename;
  } else {
    var chunks = filename.split('.').sublist(1);
    while (chunks.isNotEmpty) {
      var k = '.' + chunks.join();
      if (iconSetMap.containsKey(k)) {
        key = k;
        break;
      }
      chunks = chunks.sublist(1);
    }
  }

  if (key == null) {
    key = '.txt';
  }
  return key;
}

class FileIcon extends IconData{
  final String filename;
  FileIcon(filename):this.filename=filename.toLowerCase(), super(iconSetMap[_getIconKey(filename)]!,fontFamily: 'Seti');  
}

