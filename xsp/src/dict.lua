-- dict.lua
-- Author: cndy1860
-- Date: 2018-11-19
-- Descrip: 数据字典,用于生成单词

local modName = "dict"
local M = {}

_G[modName] = M
package.loaded[modName] = M

--词库表，源自四六级单词，4K+
M.words = {					
	"abandon", "ability", "able", "abnormal", "aboard", "about", "above", "abroad", "absence", "absent",
	"absolute", "absolutely", "absorb", "abstract", "abundant", "abuse", "academic", "academy", "accelerate", "acceleration",
	"accent", "accept", "acceptable", "acceptance", "access", "accessory", "accident", "accidental", "accommodate", "accommodation",
	"accompany", "accomplish", "accord", "accordance", "accordingly", "account", "accumulate", "accuracy", "accurate", "accuse",
	"accustom", "accustomed", "ache", "achieve", "achievement", "acid", "acquaintance", "acquire", "acre", "across",
	"act", "action", "active", "activity", "actor", "actress", "actual", "actually", "acute", "ad",
	"adapt", "add", "addition", "additional", "address", "adequate", "adjective", "adjust", "administration", "admire",
	"admission", "admit", "adopt", "adult", "advance", "advanced", "advantage", "adventure", "adverb", "advertisement",
	"advice", "advisable", "advise", "aeroplane", "affair", "affect", "affection", "afford", "afraid", "Africa",
	"African", "after", "afternoon", "afterward", "again", "against", "age", "agency", "agent", "aggressive",
	"ago", "agony", "agree", "agreement", "agriculture", "ahead", "aid", "aim", "air", "aircraft",
	"airline", "airplane", "airport", "alarm", "alcohol", "alike", "alive", "all", "allow", "alloy",
	"almost", "alone", "along", "aloud", "alphabet", "already", "also", "alter", "alternative", "although",
	"altitude", "altogether", "aluminium", "always", "a.m", "amaze", "ambition", "ambulance", "America", "American",
	"among", "amongst", "amount", "ampere", "amplify", "amuse", "analyse", "analysis", "ancestor", "anchor",
	"ancient", "and", "angel", "anger", "angle", "angry", "animal", "ankle", "announce", "announcer",
	"annoy", "annual", "another", "answer", "ant", "anticipate", "anxiety", "anxious", "any", "anybody",
	"anyhow", "anyone", "anything", "anyway", "anywhere", "apart", "apartment", "apologize", "apology", "apparatus",
	"apparent", "appeal", "appear", "appearance", "appetite", "apple", "appliance", "applicable", "application", "apply",
	"appoint", "appointment", "appreciate", "approach", "appropriate", "approval", "approve", "approximate", "approximately", "April",
	"Arabian", "arbitrary", "architecture", "area", "argue", "argument", "arise", "arithmetic", "arm", "army",
	"around", "arouse", "arrange", "arrangement", "arrest", "arrival", "arrive", "arrow", "art", "article",
	"artificial", "artist", "artistic", "as", "ash", "ashamed", "Asia", "Asian", "aside", "ask",
	"asleep", "aspect", "assemble", "assembly", "assess", "assign", "assignment", "assist", "assistant", "associate",
	"association", "assume", "assure", "astonish", "astronaut", "at", "athlete", "Atlantic", "atmosphere", "atmospheric",
	"atom", "atomic", "attach", "attack", "attain", "attempt", "attend", "attention", "attentive", "attitude",
	"attract", "attraction", "attractive", "attribute", "audience", "August", "aunt", "aural", "Australia", "Australian",
	"author", "authority", "auto", "automatic", "automation", "automobile", "autumn", "auxiliary", "available", "avenue",
	"average", "aviation", "avoid", "await", "awake", "award", "aware", "away", "awful", "awfully",
	"awkward", "ax", "axis", "baby", "back", "background", "backward", "bacteria", "bad", "badly",
	"badminton", "bag", "baggage", "bake", "balance", "ball", "balloon", "banana", "band", "bang",
	"bank", "banner", "bar", "barber", "bare", "bargain", "bark", "barn", "barrel", "barrier",
	"base", "basic", "basically", "basin", "basis", "basket", "basketball", "bat", "bath", "bathe",
	"bathroom", "battery", "battle", "bay", "B.C.", "be", "beach", "beam", "bean", "bear",
	"bear", "beard", "beast", "beat", "beautiful", "beauty", "because", "become", "bed", "bee",
	"beef", "beer", "before", "beg", "beggar", "begin", "beginner", "beginning", "behalf", "behave",
	"behavior", "behind", "being", "belief", "believe", "bell", "belong", "beloved", "below", "belt",
	"bench", "bend", "beneath", "beneficial", "benefit", "berry", "beside", "besides", "best", "bet",
	"betray", "better", "between", "beyond", "Bible", "bicycle", "big", "bike", "bill", "billion",
	"bind", "biology", "bird", "birth", "birthday", "biscuit", "bit", "bite", "bitter", "bitterly",
	"black", "blackboard", "blade", "blame", "blank", "blanket", "blast", "blaze", "bleed", "blend",
	"bless", "blind", "block", "blood", "bloom", "blossom", "blow", "blue", "board", "boast",
	"boat", "body", "boil", "bold", "bolt", "bomb", "bond", "bone", "book", "boot",
	"booth", "border", "bore", "born", "borrow", "bosom", "boss", "both", "bother", "bottle",
	"bottom", "bough", "bounce", "bound", "boundary", "bow", "bowl", "box", "box", "boy",
	"brain", "brake", "branch", "brand", "brandy", "brass", "brave", "bread", "breadth", "break",
	"breakfast", "breast", "breath", "breathe", "breed", "breeze", "brick", "bridge", "brief", "bright",
	"brighten", "brilliant", "brim", "bring", "brisk", "bristle", "Britain", "British", "brittle", "broad",
	"broadcast", "broken", "bronze", "brood", "brook", "broom", "brother", "brow", "brown", "bruise",
	"brush", "brute", "bubble", "bucket", "bud", "build", "building", "bulb", "bulk", "bull",
	"bullet", "bunch", "bundle", "burden", "bureau", "burn", "burst", "bury", "bus", "bush",
	"business", "busy", "but", "butcher", "butter", "butterfly", "button", "buy", "by", "cabbage",
	"cabin", "cabinet", "cable", "cafe", "cafeteria", "cage", "cake", "calculate", "calculation", "calculator",
	"calendar", "call", "calm", "camel", "camera", "camp", "campaign", "campus", "can", "can",
	"Canada", "Canadian", "canal", "cancel", "cancer", "candidate", "candle", "candy", "cannon", "canoe",
	"canteen", "canvas", "cap", "capable", "capacity", "capital", "captain", "captive", "capture", "car",
	"carbon", "card", "care", "career", "careful", "careless", "cargo", "carpenter", "carpet", "carriage",
	"carrier", "carrot", "carry", "cart", "carve", "case", "case", "cash", "cassette", "cast",
	"castle", "casual", "cat", "catalog", "catch", "cathedral", "cattle", "cause", "cave", "cease",
	"ceiling", "celebrate", "cell", "cellar", "cement", "cent", "centigrade", "centimetre", "central", "centre",
	"century", "ceremony", "certain", "certainly", "certainty", "certificate", "chain", "chair", "chairman", "chalk",
	"challenge", "chamber", "champion", "chance", "change", "channel", "chapter", "character", "characteristic", "charge",
	"charity", "charming", "chart", "chase", "cheap", "cheat", "check", "cheek", "cheer", "cheerful",
	"cheese", "chemical", "chemist", "chemistry", "cheque", "cherry", "chess", "chest", "chew", "chicken",
	"chief", "child", "childhood", "childish", "chill", "chimney", "chin", "China", "china", "Chinese",
	"chocolate", "choice", "choke", "choose", "chop", "Christian", "Christmas", "church", "cigarette", "cinema",
	"circle", "circuit", "circular", "circulate", "circumference", "circumstance", "citizen", "city", "civil", "civilization",
	"civilize", "claim", "clap", "clarify", "clasp", "class", "classical", "classification", "classify", "classmate",
	"classroom", "claw", "clay", "clean", "clear", "clearly", "clerk", "clever", "cliff", "climate",
	"climb", "cloak", "clock", "close", "closely", "cloth", "clothe", "clothes", "clothing", "cloud",
	"cloudy", "club", "clue", "clumsy", "coach", "coal", "coarse", "coast", "coat", "cock",
	"code", "coffee", "coil", "coin", "cold", "collapse", "collar", "colleague", "collect", "collection",
	"collective", "college", "collision", "colonel", "colony", "color", "column", "comb", "combination", "combine",
	"come", "comfort", "comfortable", "command", "commander", "comment", "commerce", "commercial", "commission", "commit",
	"committee", "common", "commonly", "communicate", "communication", "communism", "communist", "community", "companion", "company",
	"comparative", "compare", "comparison", "compass", "compel", "compete", "competent", "competition", "compile", "complain",
	"complaint", "complete", "completely", "complex", "complicate", "complicated", "component", "compose", "composition", "compound",
	"comprehension", "comprehensive", "compress", "comprise", "compromise", "compute", "computer", "comrade", "conceal", "concentrate",
	"concentration", "concept", "concern", "concerning", "concert", "conclude", "conclusion", "concrete", "condemn", "condense",
	"condition", "conduct", "conductor", "conference", "confess", "confidence", "confident", "confine", "confirm", "conflict",
	"confuse", "confusion", "congratulate", "congratulation", "congress", "conjunction", "connect", "connection", "conquer", "conquest",
	"conscience", "conscious", "consciousness", "consent", "consequence", "consequently", "conservation", "conservative", "consider", "considerable",
	"considerate", "consideration", "consist", "consistent", "constant", "constitution", "construct", "construction", "consult", "consume",
	"consumption", "contact", "contain", "container", "contemporary", "contempt", "content", "content", "contest", "continent",
	"continual", "continue", "continuous", "contract", "contradiction", "contrary", "contrast", "contribute", "control", "convenience",
	"convenient", "convention", "conventional", "conversation", "conversely", "conversion", "convert", "convey", "convince", "cook",
	"cool", "cooperate", "coordinate", "cope", "copper", "copy", "cord", "cordial", "core", "corn",
	"corner", "corporation", "correct", "correction", "correspond", "correspondent", "corresponding", "corridor", "cost", "costly",
	"cottage", "cotton", "cough", "could", "council", "count", "counter", "country", "countryside", "county",
	"couple", "courage", "course", "court", "cousin", "cover", "cow", "coward", "crack", "craft",
	"crane", "crash", "crawl", "crazy", "cream", "create", "creative", "creature", "credit", "creep",
	"crew", "cricket", "crime", "criminal", "cripple", "crisis", "critic", "critical", "criticism", "criticize",
	"crop", "cross", "crow", "crowd", "crown", "crude", "cruel", "crush", "crust", "cry",
	"crystal", "cube", "cubic", "cucumber", "cultivate", "culture", "cunning", "cup", "cupboard", "cure",
	"curiosity", "curious", "curl", "current", "curse", "curtain", "curve", "cushion", "custom", "customer",
	"cut", "cycle", "daily", "dairy", "dam", "damage", "damp", "dance", "danger", "dangerous",
	"dare", "daring", "dark", "darling", "dash", "data", "date", "daughter", "dawn", "day",
	"daylight", "dead", "deadly", "deaf", "deal", "dear", "death", "debate", "debt", "decade",
	"decay", "deceit", "deceive", "December", "decent", "decide", "decision", "deck", "declare", "decorate",
	"decrease", "deduce", "deed", "deep", "deepen", "deer", "defeat", "defect", "defence", "defend",
	"define", "definite", "definitely", "definition", "degree", "delay", "delete", "delegation", "delicate", "delicious",
	"delight", "deliver", "delivery", "demand", "democracy", "democratic", "demonstrate", "dense", "density", "deny",
	"depart", "department", "departure", "depend", "dependent", "deposit", "depress", "depth", "derive", "descend",
	"describe", "description", "desert", "deserve", "design", "desirable", "desire", "desk", "despair", "desperate",
	"despise", "despite", "destination", "destroy", "destruction", "detail", "detect", "detection", "determination", "determine",
	"develop", "development", "device", "devil", "devise", "devote", "dew", "diagram", "dial", "dialect",
	"dialog", "diameter", "diamond", "diary", "dictate", "dictation", "dictionary", "die", "differ", "difference",
	"different", "difficult", "difficulty", "dig", "digest", "digital", "diligent", "dim", "dimension", "dinner",
	"dip", "direct", "direction", "directly", "director", "dirt", "dirty", "disable", "disadvantage", "disagree",
	"disappear", "disappoint", "disaster", "disk", "discard", "discharge", "discipline", "disclose", "discourage", "discover",
	"discovery", "discuss", "discussion", "disease", "disguise", "disgust", "dish", "dishonour", "dislike", "dismiss",
	"disorder", "display", "disposal", "dispose", "displease", "dispute", "dissatisfy", "dissolve", "distance", "distant",
	"distinct", "distinction", "distinguish", "distress", "distribute", "distribution", "district", "disturb", "ditch", "dive",
	"diverse", "divide", "division", "divorce", "do", "dock", "doctor", "document", "dog", "dollar",
	"domestic", "donkey", "door", "dorm", "dormitory", "dose", "dot", "double", "doubt", "doubtful",
	"doubtless", "down", "downstairs", "downward", "dozen", "draft", "drag", "dragon", "drain", "drama",
	"dramatic", "draw", "drawer", "drawing", "dread", "dream", "dress", "drift", "drill", "drink",
	"drip", "drive", "driver", "drop", "drought", "drown", "drug", "drum", "drunk", "dry",
	"duck", "due", "dull", "dumb", "dump", "durable", "duration", "during", "dusk", "dust",
	"duty", "dwelling", "dye", "dying", "dynamic", "each", "eager", "eagle", "ear", "early",
	"earn", "earnest", "earth", "earthquake", "ease", "easily", "east", "eastern", "easy", "eat",
	"echo", "economic", "economical", "economy", "edge", "edition", "editor", "educate", "education", "effect",
	"effective", "efficiency", "efficient", "effort", "egg", "eight", "eighteen", "eighth", "eighty", "either",
	"elaborate", "elastic", "elbow", "elder", "elect", "election", "electric", "electrical", "electricity", "electron",
	"electronic", "electronics", "element", "elementary", "elephant", "elevator", "eleven", "eleventh", "eliminate", "elimination",
	"else", "elsewhere", "embarrass", "embrace", "emerge", "emergency", "emit", "emotion", "emotional", "emperor",
	"emphasis", "emphasize", "empire", "employ", "employee", "employer", "employment", "empty", "enable", "enclose",
	"encounter", "encourage", "end", "ending", "endless", "endure", "enemy", "energy", "enforce", "engage",
	"engine", "engineer", "engineering", "England", "English", "Englishman", "enjoy", "enlarge", "enormous", "enough",
	"ensure", "enter", "entertain", "enthusiasm", "enthusiastic", "entire", "entitle", "entrance", "entry", "envelope",
	"environment", "envy", "equal", "equality", "equation", "equip", "equipment", "equivalent", "era", "erect",
	"error", "escape", "especially", "essay", "essential", "establish", "establishment", "estimate", "Europe", "European",
	"evaluate", "evaporate", "eve", "even", "even", "evening", "event", "eventually", "ever", "every",
	"everybody", "everyday", "everyone", "everything", "everywhere", "evidence", "evident", "evil", "evolution", "evolve",
	"exact", "exactly", "exaggerate", "exam", "examination", "examine", "example", "exceed", "exceedingly", "excellent",
	"except", "exception", "excess", "excessive", "exchange", "excite", "exciting", "exclaim", "exclude", "exclusively",
	"excursion", "excuse", "execute", "executive", "exercise", "exert", "exhaust", "exhibit", "exhibition", "exist",
	"existence", "exit", "expand", "expansion", "expect", "expectation", "expense", "expensive", "experience", "experiment",
	"experimental", "expert", "explain", "explanation", "explode", "exploit", "explore", "explosion", "explosive", "export",
	"expose", "exposure", "express", "expression", "extend", "extension", "extensive", "extent", "exterior", "external",
	"extra", "extraordinary", "extreme", "extremely", "eye", "eyesight", "facility", "fact", "factor", "factory",
	"faculty", "fade", "Fahrenheit", "fail", "failure", "faint", "fair", "fair", "fairly", "faith",
	"faithful", "fall", "false", "fame", "familiar", "family", "famine", "famous", "fan", "fan",
	"fancy", "far", "fare", "farewell", "farm", "farmer", "farther", "fashion", "fashionable", "fast",
	"fasten", "fatal", "fate", "father", "fatigue", "fault", "faulty", "favour", "favourable",
	"favourite", "fear", "fearful", "feasible", "feast", "feather", "feature", "February", "federal", "fee",
	"feeble", "feed", "feedback", "feel", "feeling", "fellow", "female", "fence", "fertile", "fertilizer",
	"festival", "fetch", "fever", "few", "fibre", "fiction", "field", "fierce", "fifteen", "fifth",
	"fifty", "fight", "figure", "file", "fill", "film", "filter", "final", "finally", "finance",
	"financial", "find", "finding", "fine", "fine", "finger", "finish", "fire", "fireman", "firm",
	"first", "fish", "fisherman", "fist", "fit", "five", "fix", "flag", "flame", "flare",
	"flash", "flat", "flat", "flavour", "fleet", "flesh", "flexible", "flight", "float", "flock",
	"flood", "floor", "flour", "flourish", "flow", "flower", "flu", "fluent", "fluid", "flush",
	"fly", "focus", "fog", "fold", "folk", "follow", "following", "fond", "food", "fool",
	"foolish", "foot", "football", "footstep", "for", "forbid", "force", "forecast", "forehead", "foreign",
	"foreigner", "foremost", "forest", "forever", "forget", "forgive", "fork", "form", "formal", "formation",
	"former", "formula", "forth", "fortnight", "fortunate", "fortunately", "fortune", "forty", "forward", "found",
	"foundation", "fountain", "four", "fourteen", "fourth", "fox", "fraction", "fragment", "frame", "framework",
	"France", "frank", "free", "freedom", "freely", "freeze", "freight", "French", "frequency", "frequent",
	"frequently", "fresh", "friction", "Friday", "fridge", "friend", "friendly", "friendship", "frighten", "frog",
	"from", "front", "frontier", "frost", "frown", "fruit", "fruitful", "fry", "fuel", "fulfil",
	"full", "fun", "function", "fund", "fundamental", "funeral", "funny", "fur", "furious", "furnace",
	"furnish", "furniture", "further", "furthermore", "future", "gain", "gallery", "gallon", "game", "gang",
	"gap", "garage", "garbage", "garden", "gardener", "gas", "gaseous", "gasoline", "gasp", "gate",
	"gather", "gauge", "gay", "gaze", "general", "generally", "generate", "generation", "generator", "generous",
	"genius", "gentle", "gentleman", "gently", "genuine", "geography", "geometry", "germ", "German", "Germany",
	"gesture", "get", "ghost", "giant", "gift", "girl", "give", "glad", "glance", "glare",
	"glass", "glide", "glimpse", "glitter", "globe", "gloomy", "glorious", "glory", "glove", "glow",
	"glue", "go", "goal", "goat", "God", "gold", "golden", "golf", "good", "goodbye",
	"goodness", "goods", "goose", "govern", "government", "governor", "gown", "grace", "graceful", "gracious",
	"grade", "gradual", "gradually", "graduate", "grain", "gramme", "grammar", "grammatical", "grand", "granddaughter",
	"grandfather", "grandmother", "grandson", "grant", "grape", "graph", "grasp", "grass", "grateful", "gratitude",
	"grave", "gravity", "gray", "great", "greatly", "greedy", "Greek", "green", "greenhouse", "greet",
	"greeting", "grey", "grieve", "grind", "grip", "groan", "grocer", "grocery", "gross", "ground",
	"group", "grow", "growth", "guarantee", "guard", "guess", "guest", "guidance", "guide", "guilty",
	"gulf", "gum", "gun", "gunpowder", "gymnasium", "habit", "habitual", "hair", "haircut", "half",
	"hall", "halt", "hamburger", "hammer", "hand", "handful", "handkerchief", "handle", "handsome", "handwriting",
	"handy", "hang", "happen", "happiness", "happy", "harbour", "hard", "harden", "hardly", "hardship",
	"hardware", "hare", "harm", "harmful", "harmony", "harness", "harsh", "harvest", "haste", "hasten",
	"hasty", "hat", "hatch", "hate", "hateful", "hatred", "have", "hawk", "hay", "hazard",
	"he", "head", "headache", "heading", "headline", "headmaster", "headquarters", "heal", "health", "healthy",
	"heap", "hear", "heart", "heat", "heating", "heaven", "heavily", "heavy", "hedge", "heel",
	"height", "heir", "helicopter", "hell", "hello", "helmet", "help", "helpful", "helpless", "hen",
	"hence", "her", "herd", "here", "hero", "heroic", "heroine", "hers", "herself", "hesitate",
	"hi", "hide", "high", "highly", "highway", "hill", "hillside", "him", "himself", "hint",
	"hire", "his", "historical", "history", "hit", "hobby", "hold", "hole", "holiday", "hollow",
	"holy", "home", "honest", "honesty", "honey", "honeymoon", "honour", "honourable", "hook", "hope",
	"hopeful", "hopeless", "horizon", "horizontal", "horn", "horror", "horse", "horsepower", "hospital", "host",
	"hostess", "hostile", "hot", "hotel", "hour", "house", "household", "housewife", "how", "however",
	"huge", "human", "humble", "humid", "humorous", "humour", "hundred", "hunger", "hungry", "hunt",
	"hurry", "hurt", "husband", "hut", "hydrogen", "I", "ice", "idea", "ideal",
	"identical", "identify", "idiom", "idle", "i.e.", "if", "ignorant", "ignore", "ill", "illegal",
	"illness", "illustrate", "illustration", "image", "imaginary", "imagination", "imagine", "imitate", "immediate", "immediately",
	"immense", "immigrant", "impact", "impatient", "implication", "imply", "import", "importance", "important", "impose",
	"impossible", "impress", "impression", "impressive", "imprison", "improve", "improvement", "in", "inch", "incident",
	"incline", "include", "income", "incorrect", "increase", "increasingly", "indeed", "indefinite", "independence", "independent",
	"index", "India", "Indian", "indicate", "indication", "indifferent", "indignant", "indirect", "indispensable", "individual",
	"indoors", "industrial", "industrialize", "industry", "inefficient", "inevitable", "inexpensive", "infant", "infect", "infer",
	"inferior", "infinite", "influence", "influential", "inform", "information", "inhabit", "inhabitant", "inherit", "initial",
	"injection", "injure", "injury", "ink", "inn", "inner", "innocent", "input", "inquire", "inquiry",
	"insect", "insert", "inside", "insist", "inspect", "inspection", "inspire", "install", "installation", "instance",
	"instant", "instantly", "instead", "instinct", "institute", "institution", "instruct", "instruction", "instrument", "insufficient",
	"insult", "insurance", "insure", "intellectual", "intelligence", "intelligent", "intend", "intense", "intensity", "intensive",
	"intention", "intentional", "interaction", "interest", "interesting", "interfere", "interference", "interior", "intermediate", "internal",
	"international", "interpret", "interpretation", "interpreter", "interrupt", "interruption", "interval", "interview", "intimate", "into",
	"introduce", "introduction", "invade", "invasion", "invent", "invention", "inventor", "invest", "investigate", "investigation",
	"investment", "invisible", "invitation", "invite", "involve", "inward", "iron", "irregular", "island", "isolate",
	"issue", "it", "Italian", "item", "its", "itself", "jacket", "jail", "jam", "jam",
	"January", "Japan", "Japanese", "jar", "jaw", "jazz", "jealous", "jet", "jewel", "jewish",
	"job", "join", "joint", "joke", "jolly", "journal", "journalist", "journey", "joy", "joyful",
	"judge", "judgement", "juice", "July", "jump", "June", "jungle", "junior", "jury", "just",
	"justice", "justify", "keen", "keep", "keeper", "kettle", "key", "keyboard", "kick", "kid",
	"kill", "kilogram", "kilometer", "kind", "kind", "kindness", "king", "kingdom", "kiss", "kitchen",
	"kite", "knee", "kneel", "knife", "knit", "knob", "knock", "knot", "know", "knowledge",
	"lab", "label", "laboratory", "labour", "lace", "lack", "ladder", "lady", "lag", "lake",
	"lamb", "lame", "lamp", "land", "landing", "landlady", "landlord", "lane", "language", "lantern",
	"lap", "large", "largely", "laser", "last", "last", "late", "lately", "later", "Latin",
	"latter", "laugh", "laughter", "launch", "laundry", "lavatory", "law", "lawn", "lawyer", "lay",
	"layer", "layout", "lazy", "lead", "lead", "leader", "leadership", "leading", "leaf", "league",
	"leak", "lean", "leap", "learn", "learned", "learning", "least", "leather", "leave", "lecture",
	"left", "leg", "legal", "legend", "leisure", "lemon", "lend", "length", "lens", "less",
	"lessen", "lesson", "lest", "let", "letter", "level", "lever", "liable", "liar", "liberal",
	"liberate", "liberation", "liberty", "librarian", "library", "license", "lick", "lid", "lie", "lie",
	"lieutenant", "life", "lifetime", "lift", "light", "light", "lighten", "lightly", "lightning", "like",
	"like", "likely", "likewise", "limb", "lime", "limit", "limitation", "limited", "line", "linen",
	"liner", "link", "lion", "lip", "liquid", "liquor", "list", "listen", "listener", "liter",
	"literary", "literature", "little", "live", "lively", "liver", "living", "load", "loaf",
	"loan", "local", "locate", "location", "lock", "locomotive", "lodge", "log", "logic", "logical",
	"lonely", "long", "long", "look", "loop", "loose", "loosen", "lord", "lorry", "lose",
	"loss", "lot", "loud", "loudspeaker", "love", "lovely", "lover", "low", "lower", "loyal",
	"loyalty", "luck", "lucky", "luggage", "lumber", "lump", "lunch", "lung", "luxury", "machine",
	"mad", "madam", "magazine", "magic", "magnet", "magnetic", "magnificent", "maid", "mail", "main",
	"mainly", "mainland", "maintain", "maintenance", "major", "majority", "make", "male", "man", "manage",
	"management", "manager", "mankind", "manly", "manner", "manual", "manufacture", "manufacturer", "many", "map",
	"marble", "March", "march", "margin", "marine", "mark", "market", "marriage", "married", "marry",
	"marvelous", "Marxisim", "Marxist", "mask", "mass", "master", "masterpiece", "mat", "match", "match",
	"mate", "material", "materialism", "mathematical", "mathematics", "maths", "matter", "mature", "maximum", "May",
	"may", "maybe", "mayor", "me", "meadow", "meal", "mean", "mean", "mean", "meaning",
	"means", "meantime", "meanwhile", "measurable", "measure", "measurement", "meat", "mechanic", "mechanical", "mechanically",
	"mechanics", "medal", "medical", "medicine", "Mediterranean", "medium", "meet", "meeting", "melon", "melt",
	"member", "memorial", "memory", "mend", "mental", "mention", "menu", "merchant", "mercury", "Mercury",
	"mercy", "mere", "merely", "merit", "merry", "mess", "message", "messenger", "metal", "meter",
	"method", "metre", "metric", "microcomputer", "microphone", "microscope", "midday", "middle", "midnight", "midst",
	"might", "might", "mild", "mile", "military", "milk", "mill", "millimetre", "million", "mind",
	"mine", "mine", "miner", "mineral", "minimum", "minister", "ministry", "minor", "minority", "minus",
	"minute", "minute", "miracle", "mirror", "miserable", "mislead", "miss", "miss", "missile", "missing",
	"mission", "mist", "mistake", "Mister", "mistress", "misunderstand", "mix", "mixture", "moan", "mobile",
	"mode", "model", "moderate", "modern", "modest", "modify", "moist", "moisture", "molecule", "moment",
	"Monday", "money", "monitor", "monkey", "month", "monthly", "monument", "mood", "moon", "moral",
	"more", "moreover", "morning", "mortal", "mosquito", "most", "mostly", "mother", "motion", "motivate",
	"motive", "motor", "mould", "mount", "mountain", "mourn", "mouse", "mouth", "mouthful", "move",
	"movement", "movie", "much", "mud", "muddy", "mug", "multiple", "multiply", "murder", "murderer",
	"muscle", "museum", "mushroom", "music", "musical", "musician", "must", "mute", "mutter", "mutton",
	"mutual", "my", "myself", "mysterious", "mystery", "nail", "naked", "name", "namely", "nap",
	"narrow", "nasty", "nation", "national", "nationality", "native", "natural", "naturally", "nature", "naughty",
	"naval", "navigation", "navy", "near", "nearby", "nearly", "neat", "necessarily", "necessary", "necessity",
	"neck", "necklace", "need", "needle", "needless", "negative", "neglect", "Negro", "neighbour", "neighbourhood",
	"neither", "nephew", "nerve", "nervous", "nest", "net", "network", "neutral", "never", "nevertheless",
	"new", "newly", "news", "newspaper", "next", "nice", "niece", "night", "nine", "nineteen",
	"ninety", "ninth", "nitrogen", "no", "noble", "nobody", "nod", "noise", "noisy", "none",
	"nonsense", "noon", "nor", "normal", "normally", "north", "northeast", "northern", "northwest", "nose",
	"not", "note", "notebook", "nothing", "notice", "noticeable", "noun", "novel", "November", "now",
	"nowadays", "nowhere", "nuclear", "nucleus", "nuisance", "number", "numerous", "nurse", "nursery", "nut",
	"nylon", "oak", "oar", "obey", "object", "object", "objection", "objective", "oblige", "observation",
	"observe", "observer", "obstacle", "obtain", "obvious", "obviously", "occasion", "occasional", "occasionally", "occupation",
	"occupy", "occur", "occurrence", "ocean", "Oceania", "o'clock", "October", "odd", "odour", "of",
	"off", "offend", "offer", "office", "officer", "official", "often", "oh", "oil", "okay",
	"old", "omit", "on", "once", "one", "oneself", "onion", "only", "onto", "open",
	"opening", "opera", "operate", "operation", "operational", "operator", "opinion", "opponent", "opportunity", "oppose",
	"opposite", "oppress", "optical", "optimistic", "option", "optional", "or", "oral", "orange", "orbit",
	"orchestra", "order", "orderly", "ordinary", "ore", "organ", "organic", "organism", "organization", "organize",
	"oriental", "origin", "original", "ornament", "orphan", "other", "otherwise", "ought", "ounce", "our",
	"ours", "ourselves", "out", "outcome", "outdoor", "outdoors", "outer", "outlet", "outline", "outlook",
	"output", "outset", "outside", "outskirt", "outstanding", "outward", "outwards", "oven", "over", "overall",
	"overcoat", "overcome", "overhead", "overlook", "overnight", "overseas", "overtake", "overtime", "owe", "owl",
	"own", "owner", "ownership", "ox", "phase", "phenomenon", "philosopher", "philosophy", "phone", "photograph",
	"photographic", "phrase", "physical", "physician", "physicist", "physics", "piano", "pick", "pick", "picnic",
	"picture", "pie", "piece", "pierce", "pig", "pigeon", "pile", "pill", "pillar", "pillow",
	"pilot", "pin", "pinch", "pine", "pink", "pint", "pioneer", "pipe", "pipeline", "pistol",
	"pit", "pitch", "pitch", "pity", "place", "plain", "plan", "plane", "planet", "plant",
	"plantation", "plaster", "plastic", "plate", "platform", "play", "player", "playground", "pleasant", "please",
	"pleasure", "plentiful", "plenty", "plot", "plough", "pluck", "plug", "plunge", "plural", "plus",
	"P.M.", "pocket", "poem", "poet", "poetry", "point", "poison", "poisonous", "pole", "pole",
	"police", "policeman", "policy", "polish", "polite", "political", "politician", "politics", "pollute", "pollution",
	"pond", "pool", "pool", "poor", "pop", "pop", "popular", "population", "porch", "pork",
	"porridge", "port", "portable", "porter", "portion", "portrait", "Portuguese", "position", "positive", "possess",
	"possession", "possibility", "possible", "possibly", "post", "post", "post", "postage", "postman", "postpone",
	"pot", "potato", "potential", "pound", "pound", "pour", "poverty", "powder", "power", "powerful",
	"practical", "practically", "practice", "practise", "praise", "pray", "prayer", "precaution", "preceding", "precious",
	"precise", "precision", "predict", "preface", "prefer", "preferable", "preference", "prejudice", "preliminary", "premier",
	"preparation", "prepare", "preposition", "prescribe", "presence", "present", "present", "present", "presently", "preserve",
	"president", "press", "pressure", "pretend", "pretty", "prevail", "prevent", "previous", "previously", "price",
	"pride", "priest", "primarily", "primary", "prime", "primitive", "prince", "princess", "principal", "principle",
	"print", "prior", "prison", "prisoner", "private", "privilege", "prize", "probability", "probable", "probably",
	"problem", "procedure", "proceed", "process", "procession", "proclaim", "produce", "product", "production", "productive",
	"profession", "professional", "professor", "profit", "program", "progress", "progressive", "prohibit", "project", "prominent",
	"promise", "promising", "promote", "prompt", "pronoun", "pronounce", "pronunciation", "proof", "proper", "properly",
	"property", "proportion", "proportional", "proposal", "propose", "prospect", "prosperity", "prosperous", "protect", "protection",
	"protective", "protein", "protest", "proud", "prove", "provide", "provided", "province", "provision", "psychological",
	"public", "publication", "publish", "pudding", "puff", "pull", "pulse", "pump", "punch", "punch",
	"punctual", "punish", "punishment", "pupil", "pupil", "puppet", "purchase", "pure", "purely", "purify",
	"purity", "purple", "purpose", "purse", "pursue", "pursuit", "push", "put", "puzzle", "qualify",
	"quality", "quantity", "quarrel", "quart", "quarter", "quarterly", "queen", "queer", "question", "queue",
	"quick", "quicken", "quickly", "quiet", "quilt", "quit", "quite", "quiz", "quotation", "quote",
	"rabbit", "race", "race", "racial", "rack", "rack", "racket", "radar", "radiate", "radiation",
	"radio", "radioactive", "radioactivity", "radish", "radium", "radius", "rag", "rage", "raid", "rail",
	"railroad", "railway", "rain", "rainbow", "rainy", "raise", "rake", "range", "rank", "rapid",
	"rapidly", "rare", "rarely", "rat", "rate", "rather", "ratio", "rational", "raw", "ray",
	"razor", "reach", "react", "reaction", "read", "reader", "readily", "reading", "ready", "real",
	"reality", "realize", "really", "realm", "reap", "rear", "rear", "reason", "reasonable", "rebel",
	"rebellion", "recall", "receipt", "receive", "receiver", "recent", "recently", "reception", "recite", "recognition",
	"recognize", "recollect", "recommend", "recommendation", "record", "recorder", "recover", "recovery", "red", "reduce",
	"reduction", "reed", "reel", "refer", "reference", "refine", "reflect", "reflection", "reflexion", "reform",
	"refresh", "refreshment", "refrigerator", "refuge", "refusal", "refuse", "refute", "regard", "regarding", "regardless",
	"region", "register", "regret", "regular", "regularly", "regulate", "regulation", "rehearsal", "reign", "rein",
	"reinforce", "reject", "rejoice", "relate", "relation", "relationship", "relative", "relatively", "relativity", "relax",
	"release", "relevant", "reliability", "reliable", "reliance", "relief", "relieve", "religion", "religious", "reluctant",
	"rely", "remain", "remains", "remark", "remarkable", "remedy", "remember", "remind", "remote", "removal",
	"remove", "render", "renew", "rent", "repair", "repeat", "repeatedly", "repent", "repetition", "replace",
	"reply", "report", "reporter", "represent", "representative", "reproach", "reproduce", "republic", "republican", "reputation",
	"request", "require", "requirement", "rescue", "research", "researcher", "resemble", "reserve", "reservior", "residence",
	"resident", "resign", "resignation", "resist", "resistance", "resistant", "resolution", "resolve", "resort", "resource",
	"respect", "respectful", "respective", "respectively", "respond", "response", "responsibility", "responsible", "rest", "rest",
	"restaurant", "restless", "restore", "restrain", "restraint", "restrict", "restriction", "result", "resume", "retain",
	"retell", "retire", "retreat", "return", "reveal", "revenge", "reverse", "review", "revise", "revolt",
	"revolution", "revolutionary", "reward", "rhythm", "rib", "ribbon", "rice", "rich", "rid", "riddle",
	"ride", "rider", "ridge", "ridiculous", "rifle", "right", "rigid", "ring", "ring", "ripe",
	"ripen", "rise", "risk", "rival", "river", "road", "roar", "roast", "rob", "robber",
	"robbery", "robe", "robot", "rock", "rock", "rocket", "rod", "role", "roll", "roller",
	"Roman", "romantic", "roof", "room", "root", "rope", "rose", "rot", "rotary", "rotate",
	"rotation", "rotten", "rough", "roughly", "round", "rouse", "route", "routine", "row", "row",
	"royal", "rub", "rubber", "rubbish", "rude", "rug", "ruin", "rule", "ruler", "rumour",
	"run", "runner", "rural", "rush", "Russian", "rust", "rusty", "sack", "sacred", "sacrifice",
	"sad", "saddle", "sadly", "sadness", "safe", "safe", "safely", "safety", "sail", "sailor",
	"saint", "sake", "salad", "salary", "sale", "salesman", "salt", "salute", "same", "sample",
	"sand", "sandwich", "sandy", "satellite", "satisfaction", "satisfactory", "satisfy", "Saturday", "sauce", "saucer",
	"sausage", "save", "saving", "saw", "say", "scale", "scale", "scan", "scar", "scarce",
	"scarcely", "scare", "scarf", "scatter", "scene", "scenery", "scent", "schedule", "scheme", "scholar",
	"scholarship", "school", "science", "scientific", "scientist", "scissors", "scold", "scope", "score", "scorn",
	"scout", "scrape", "scratch", "scream", "screen", "screw", "sea", "seal", "seal", "seaman",
	"seaport", "search", "season", "seat", "second", "second", "secondary", "secondly", "secret", "secretary",
	"section", "secure", "security", "see", "seed", "seek", "seem", "seize", "seldom", "select",
	"selection", "self", "selfish", "sell", "seller", "semester", "semiconductor", "senate", "send", "senior",
	"sense", "sensible", "sensitive", "sentence", "separate", "separately", "separation", "September", "sequence", "series",
	"serious", "seriously", "servant", "serve", "service", "session", "set", "setting", "settle", "settlement",
	"seven", "seventeen", "seventh", "seventy", "several", "severe", "severely", "sew", "***", "shade",
	"shadow", "shady", "shake", "shall", "shallow", "shame", "shampoo", "shape", "share", "sharp",
	"sharpen", "sharply", "shave", "she", "shear", "shed", "shed", "sheep", "sheet", "shelf",
	"shell", "shelter", "shepherd", "shield", "shift", "shilling", "shine", "ship", "shirt", "shiver",
	"shock", "shoe", "shoot", "shop", "shopkeeper", "shopping", "shore", "short", "shortage", "shortcoming",
	"shortly", "shot", "should", "shoulder", "shout", "show", "shower", "shriek", "shrink", "shut",
	"shy", "sick", "sickness", "side", "sideways", "sigh", "sight", "sightseeing", "sign", "signal",
	"signature", "significance", "significant", "silence", "silent", "silk", "silly", "silver", "similar", "similarly",
	"simple", "simplicity", "simplify", "simply", "sin", "since", "sincere", "sing", "singer", "single",
	"singular", "sink", "sir", "sister", "sit", "site", "situation", "six", "sixteen", "sixth",
	"sixty", "size", "skate", "sketch", "ski", "skill", "skilled", "skillful", "skim", "skin",
	"skirt", "sky", "slam", "slave", "slavery", "sleep", "sleepy", "sleeve", "slender", "slice",
	"slide", "slight", "slightly", "slip", "slipper", "slippery", "slit", "slogan", "slope", "slow",
	"slowly", "slum", "sly", "small", "smart", "smell", "smile", "smog", "smoke", "smooth",
	"smoothly", "snake", "snow", "snowstorm", "snowy", "so", "soak", "soap", "sob", "sober",
	"soccer", "social", "socialism", "socialist", "society", "sock", "soda", "soft", "softly",
	"soil", "soil", "solar", "soldier", "sole", "sole", "solely", "solemn", "solid", "soluble",
	"solution", "solve", "some", "somebody", "somehow", "someone", "something", "sometime", "sometimes", "somewhat",
	"somewhere", "son", "song", "soon", "sophisticated", "sore", "sorrow", "sorry", "sort", "soul",
	"sound", "sound", "soup", "sour", "source", "south", "southeast", "southern", "southwest", "Soviet",
	"sow", "space", "spacecraft", "spaceship", "spade", "span", "Spanish", "spare", "spark", "sparkle",
	"sparrow", "speak", "speaker", "spear", "special", "specialist", "speciality", "specialize", "specially", "specific",
	"specify", "specimen", "spectacle", "speech", "speed", "spell", "spelling", "spend", "sphere", "spider",
	"spill", "spin", "spirit", "spiritual", "spit", "splash", "splendid", "split", "spoil", "sponge",
	"sponsor", "spontaneous", "spoon", "sport", "sportsman", "spot", "spray", "spread", "spring", "spring",
	"springtime", "sprinkle", "spur", "spy", "square", "squeeze", "squirrel", "stab", "stability", "stable",
	"stable", "stack", "stadium", "staff", "stage", "stain", "stair", "staircase", "stake", "stale",
	"stamp", "stand", "standard", "standpoint", "star", "stare", "start", "startle", "starve", "state",
	"state", "statement", "statesman", "static", "station", "statistical", "statue", "status", "stay", "steadily",
	"steady", "steal", "steam", "steamer", "steel", "steep", "steer", "stem", "step", "stern",
	"steward", "stewardess", "stick", "sticky", "stiff", "stiffen", "still", "stimulate", "sting", "stir",
	"stitch", "stock", "stocking", "stomach", "stone", "stony", "stool", "stoop", "stop", "storage",
	"store", "storey", "storm", "stormy", "story", "stove", "straight", "strain", "strange", "stranger",
	"strap", "strategy", "straw", "strawberry", "stream", "street", "strength", "strengthen", "stress", "stretch",
	"strict", "strictly", "strike", "string", "strip", "stripe", "stroke", "stroke", "strong", "strongly",
	"structural", "structure", "struggle", "student", "study", "stuff", "stumble", "stupid", "style", "subject",
	"submarine", "submerge", "submit", "subsequent", "substance", "substantial", "substitute", "subtract", "suburb", "subway",
	"succeed", "success", "successful", "successfully", "succession", "successive", "such", "suck", "sudden", "suddenly",
	"suffer", "sufficient", "sufficiently", "sugar", "suggest", "suggestion", "suit", "suitable", "sulphur", "sum",
	"summarize", "summary", "summer", "sun", "Sunday", "sunlight", "sunny", "sunrise", "sunset", "sunshine",
	"super", "superficial", "superior", "supermarket", "supper", "supplement", "supply", "support", "suppose", "supreme",
	"sure", "surely", "surface", "surgeon", "surgery", "surname", "surprise", "surprising", "surprisingly", "surrender",
	"surround", "surroundings", "survey", "survive", "suspect", "suspend", "suspicion", "sustain", "swallow", "swallow",
	"swamp", "swan", "swarm", "sway", "swear", "sweat", "sweater", "sweep", "sweet", "swell",
	"swift", "swim", "swing", "Swiss", "switch", "sword", "symbol", "sympathetic", "sympathize", "sympathy",
	"synthetic", "system", "systematic(al)", "table", "tablet", "tag", "tail", "tailor", "take", "tale",
	"talent", "talk", "tall", "tame", "tan", "tank", "tap", "tap", "tape", "target",
	"task", "taste", "tax", "taxi", "tea", "teach", "teacher", "teaching", "team", "tear",
	"tear", "technical", "technician", "technique", "technology", "tedious", "teenager", "telegram", "telegraph", "telephone",
	"telescope", "television", "tell", "temper", "temperature", "temple", "temporary", "tempt", "temptation", "ten",
	"tenant", "tend", "tend", "tendency", "tender", "tennis", "tense", "tense", "tent", "tenth",
	"term", "terminal", "terrible", "terrific", "territory", "terror", "test", "text", "textbook", "textile",
	"than", "thank", "that", "the", "theatre", "their", "theirs", "them", "themselves", "then",
	"theoretical", "theory", "there", "thereby", "therefore", "thermometer", "these", "they", "thick", "thickness",
	"thief", "thin", "thing", "think", "third", "thirdly", "thirst", "thirsty", "thirteen", "thirty",
	"this", "thorn", "thorough", "those", "though", "thought", "thoughtful", "thousand", "thread", "threat",
	"threaten", "three", "thrill", "thrive", "throat", "throne", "throng", "through", "throughout", "throw",
	"thrust", "thumb", "thunder", "Thursday", "thus", "tick", "ticket", "tide", "tidy", "tie",
	"tiger", "tight", "till", "timber", "time", "timetable", "timid", "tin", "tiny", "tip",
	"tip", "tire", "tired", "tissue", "title", "to", "toast", "toast", "tobacco", "today",
	"toe", "together", "toilet", "tolerance", "tolerate", "tomato", "tomb", "tomorrow", "ton", "tone",
	"tongue", "tonight", "too", "tool", "tooth", "top", "topic", "torch", "torrent", "tortoise",
	"torture", "toss", "total", "touch", "tough", "tour", "tourist", "toward(s)", "towel", "tower",
	"town", "toy", "trace", "track", "tractor", "trade", "tradition", "traditional", "traffic", "tragedy",
	"trail", "train", "training", "traitor", "tram", "tramp", "transfer", "transform", "transformation", "transformer",
	"transistor", "translate", "translation", "transmission", "transmit", "transparent", "transport", "transportation", "trap", "travel",
	"tray", "treason", "treasure", "treat", "treatment", "treaty", "tree", "tremble", "tremendous", "trend",
	"trial", "triangle", "tribe", "trick", "trifle", "trim", "trip", "triumph", "troop", "tropical",
	"trouble", "troublesome", "trousers", "truck", "true", "truly", "trumpet", "trunk", "trust", "truth",
	"try", "tub", "tube", "tuck", "Tuesday", "tuition", "tumble", "tune", "tunnel", "turbine",
	"turbulent", "turkey", "turn", "turning", "turnip", "tutor", "twelfth", "twelve", "twentieth", "twenty",
	"twice", "twin", "twinkle", "twist", "two", "type", "typewriter", "typhoon", "typical", "typist",
	"tyre", "U", "ugly", "ultimate", "ultimately", "umbrella", "unable", "unbearable", "uncertain", "uncle",
	"uncomfortable", "unconscious", "uncover", "under", "undergo", "undergraduate", "underground", "underline", "underneath", "understand",
	"understanding", "undertake", "undertaking", "undo", "undoubtedly", "uneasy", "unexpected", "unfair", "unfortunate", "unfortunately",
	"unhappy", "uniform", "union", "unique", "unit", "unite", "unity", "universal", "universe", "university",
	"unjust", "unkind", "unknown", "unless", "unlike", "unlikely", "unload", "unlucky", "unnecessary", "unpleasant",
	"unsatisfactory", "unstable", "unsuitable", "until", "unusual", "unusually", "unwilling", "up", "upon", "upper",
	"upright", "upset", "upstairs", "upward", "upwards", "urge", "urgent", "us",
	"usage", "use", "used", "used", "useful", "useless", "user", "usual", "usually", "utility",
	"utilize", "utmost", "utter", "utter", "vacant", "vacation", "vacuum", "vague", "vain", "valid",
	"valley", "valuable", "value", "van", "vanish", "vanity", "vapour", "variable", "variation", "variety",
	"various", "vary", "vase", "vast", "vegetable", "vehicle", "veil", "velocity", "velvet", "venture",
	"verb", "verify", "version", "vertical", "very", "vessel", "vest", "veteran", "vex", "via",
	"vibrate", "vibration", "vice", "vice", "victim", "victorious", "victory", "video", "view", "viewpoint",
	"vigorous", "village", "vine", "vinegar", "violence", "violent", "violet", "violin", "virtually", "virtue",
	"visible", "vision", "visit", "visitor", "visual", "vital", "vitamin", "vivid", "vocabulary", "voice",
	"volcano", "volleyball", "volt", "voltage", "volume", "voluntary", "vote", "voyage", "W", "wage",
	"wage", "waggon", "waist", "wait", "waiter", "wake", "waken", "walk", "wall", "wallet",
	"wander", "want", "war", "warm", "warmth", "warn", "wash", "waste", "watch", "water",
	"waterfall", "waterproof", "wave", "wavelength", "wax", "way", "we", "weak", "weaken", "weakness",
	"wealth", "wealthy", "weapon", "wear", "weary", "weather", "weave", "wedding", "Wednesday", "weed",
	"week", "weekday", "weekend", "weekly", "weep", "weigh", "weight", "welcome", "weld", "welfare",
	"well", "well", "west", "western", "westward", "wet", "what", "whatever", "wheat",
	"wheel", "when", "whenever", "where", "wherever", "whether", "which", "whichever", "while", "whilst",
	"whip", "whirl", "whisky", "whisper", "whistle", "white", "whitewash", "who", "whoever", "whole",
	"wholly", "whom", "whose", "why", "wicked", "wide", "widely", "widen", "widespread", "widow",
	"width", "wife", "wild", "will", "willing", "win", "wind", "wind", "window", "wine",
	"wing", "winner", "winter", "wipe", "wire", "wireless", "wisdom", "wise", "wish", "wit",
	"with", "withdraw", "within", "without", "withstand", "witness", "wolf", "woman", "wonder", "wonderful",
	"wood", "wooden", "wool", "woollen", "word", "work", "worker", "workman", "workshop", "world",
	"worm", "worry", "worse", "worship", "worst", "worth", "worthless", "worthwhile", "worthy",
	"would", "wound", "wrap", "wreath", "wreck", "wrist", "write", "writer", "writing", "wrong",
	"yard", "yard", "yawn", "year", "yearly", "yell", "yellow", "yes", "yesterday",
	"yet", "yield", "you", "young", "your", "yours", "yourself", "youth", "youthful", "zeal",
	"zealous", "zebra", "zero", "zone", "zoo",
}

--获取保存在WORD_INDEX中的上一次使用的单词索引，主要用于顺序获取单词
local function getLastWordIndex()
	local index = tonumber(getStringConfig("WORD_INDEX", "0"))
	if index > #M.words then	--当超出索引就置零
		updateWordIndex(0)
		index = tonumber(getStringConfig("WORD_INDEX", "0"))
	end
	return index
end

--更新(最后一次使用的)索引
local function updateWordIndex(index)
	setStringConfig("WORD_INDEX", tostring(index))
end

--从词源表按顺序获取一个单词，通过WORD_INDEX维持顺序
function M.getAWord()	--顺序获取一个单词
	local lastIndex = getLastWordIndex()
	
	updateWordIndex(lastIndex + 1)

	return M.words[lastIndex + 1]
end

--从词源表随机获取一个单词
function M.getRandomWord()	--获取一个随机单词
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	return M.words[math.random(1, #M.words)]
end

--获取一个以preStr开头的随机单词
function M.getPrefixWord(preStr)	
	if preStr == nil then
		return nil
	end
	
	local tmpTable = {}
	
	for k, v in pairs(M.words) do
		local i, _ = string.find(v, preStr)
		if i == 1 then
			table.insert(tmpTable, v)
		end
	end
	
	if #tmpTable ~= 0 then
		math.randomseed(tostring(os.time()):reverse():sub(1, 7))
		return tmpTable[math.random(1, #tmpTable)]
	end
	
	return nil
end

--获取一个以suffStr结尾的随机单词
function M.getSuffixWord(suffStr)
	if suffStr == nil then
		return nil
	end
	
	local tmpTable = {}
	
	for k, v in pairs(M.words) do
		local _, j = string.find(v, suffStr)
		if j == string.len(v) then
			table.insert(tmpTable, v)
		end
	end
	
	if #tmpTable ~= 0 then
		math.randomseed(tostring(os.time()):reverse():sub(1, 7))
		return tmpTable[math.random(1, #tmpTable)]
	end
	
	return nil
end

--获取一个以preStr开头和suffStr结尾的随机单词
function M.getPreSuffixWord(preSrt, suffStr)
	if suffStr == nil or preSrt == nil then
		return nil
	end
	
	local tmpTable = {}
	
	for k, v in pairs(M.words) do
		local i, _ = string.find(v, preSrt)
		local _, j = string.find(v, suffStr)
		if i == 1 and j == string.len(v) then
			table.insert(tmpTable, v)
		end
	end
	
	if #tmpTable ~= 0 then
		math.randomseed(tostring(os.time()):reverse():sub(1, 7))
		return tmpTable[math.random(1, #tmpTable)]
	end
	
	return nil
end

--获取一个不超过limit长度的随机单词
function M.getLimitLenWord(limit)
	local tmp = M.getRandomWord()
	if string.len(tmp) > limit then
		return string.sub(tmp, 1, limit)
	end
	
	return tmp
end

