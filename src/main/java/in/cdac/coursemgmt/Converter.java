package in.cdac.coursemgmt;

public class Converter {
//	public static String toHTML(String s) {
//		StringBuffer sb = new StringBuffer();
//		int n = s.length();
//
//		for (int i = 0; i < n; ++i) {
//			char c = s.charAt(i);
//			switch (c) {
//				case '\t' :
//					sb.append("&#9;");
//					break;
//				case '!' :
//					sb.append("&#33;");
//					break;
//				case '"' :
//					sb.append("&quot;");
//					break;
//				case '#' :
//					sb.append("&#35;");
//					break;
//				case '$' :
//					sb.append("&#36;");
//					break;
//				case '%' :
//					sb.append("&#37;");
//					break;
//				case '&' :
//					sb.append("&amp;");
//					break;
//				case '\'' :
//					sb.append("&#39;");
//					break;
//				case '(' :
//					sb.append("&#40;");
//					break;
//				case ')' :
//					sb.append("&#41;");
//					break;
//				case '*' :
//					sb.append("&#42;");
//					break;
//				case '+' :
//					sb.append("&#43;");
//					break;
//				case ',' :
//					sb.append("&#44;");
//					break;
//				case '-' :
//					sb.append("&#45;");
//					break;
//				case '.' :
//					sb.append("&#46;");
//					break;
//				case '/' :
//					sb.append("&#47;");
//					break;
//				case ':' :
//					sb.append("&#58;");
//					break;
//				case ';' :
//					sb.append("&#59;");
//					break;
//				case '<' :
//					sb.append("&lt;");
//					break;
//				case '=' :
//					sb.append("&#61;");
//					break;
//				case '>' :
//					sb.append("&gt;");
//					break;
//				case '?' :
//					sb.append("&#63;");
//					break;
//				case '@' :
//					sb.append("&#64;");
//					break;
//				case '[' :
//					sb.append("&#91;");
//					break;
//				case '\\' :
//					sb.append("&#92;");
//					break;
//				case ']' :
//					sb.append("&#93;");
//					break;
//				case '^' :
//					sb.append("&#94;");
//					break;
//				case '_' :
//					sb.append("&#95;");
//					break;
//				case '`' :
//					sb.append("&lsquo;");
//					break;
//				case '{' :
//					sb.append("&#123;");
//					break;
//				case '|' :
//					sb.append("&#124;");
//					break;
//				case '}' :
//					sb.append("&#125;");
//					break;
//				case '~' :
//					sb.append("&#126;");
//					break;
//				case '¦' :
//					sb.append("&brvbar;");
//					break;
//				case '©' :
//					sb.append("&copy;");
//					break;
//				case '«' :
//					sb.append("&laquo;");
//					break;
//				case '¬' :
//					sb.append("&not;");
//					break;
//				case '®' :
//					sb.append("&reg;");
//					break;
//				case '°' :
//					sb.append("&deg;");
//					break;
//				case '²' :
//					sb.append("&sup2;");
//					break;
//				case '³' :
//					sb.append("&sup3;");
//					break;
//				case 'µ' :
//					sb.append("&micro;");
//					break;
//				case '»' :
//					sb.append("&raquo;");
//					break;
//				case '¼' :
//					sb.append("&frac14;");
//					break;
//				case '½' :
//					sb.append("&frac12;");
//					break;
//				case 'À' :
//					sb.append("&Agrave;");
//					break;
//				case 'Â' :
//					sb.append("&Acirc;");
//					break;
//				case 'Ä' :
//					sb.append("&Auml;");
//					break;
//				case 'Å' :
//					sb.append("&Aring;");
//					break;
//				case 'Æ' :
//					sb.append("&AElig;");
//					break;
//				case 'Ç' :
//					sb.append("&Ccedil;");
//					break;
//				case 'È' :
//					sb.append("&Egrave;");
//					break;
//				case 'É' :
//					sb.append("&Eacute;");
//					break;
//				case 'Ê' :
//					sb.append("&Ecirc;");
//					break;
//				case 'Ë' :
//					sb.append("&Euml;");
//					break;
//				case 'Ï' :
//					sb.append("&Iuml;");
//					break;
//				case 'Ô' :
//					sb.append("&Ocirc;");
//					break;
//				case 'Ö' :
//					sb.append("&Ouml;");
//					break;
//				case '×' :
//					sb.append("&#215;");
//					break;
//				case 'Ø' :
//					sb.append("&Oslash;");
//					break;
//				case 'Ù' :
//					sb.append("&Ugrave;");
//					break;
//				case 'Û' :
//					sb.append("&Ucirc;");
//					break;
//				case 'Ü' :
//					sb.append("&Uuml;");
//					break;
//				case 'ß' :
//					sb.append("&szlig;");
//					break;
//				case 'à' :
//					sb.append("&agrave;");
//					break;
//				case 'â' :
//					sb.append("&acirc;");
//					break;
//				case 'ä' :
//					sb.append("&auml;");
//					break;
//				case 'å' :
//					sb.append("&aring;");
//					break;
//				case 'æ' :
//					sb.append("&aelig;");
//					break;
//				case 'ç' :
//					sb.append("&ccedil;");
//					break;
//				case 'è' :
//					sb.append("&egrave;");
//					break;
//				case 'é' :
//					sb.append("&eacute;");
//					break;
//				case 'ê' :
//					sb.append("&ecirc;");
//					break;
//				case 'ë' :
//					sb.append("&euml;");
//					break;
//				case 'ï' :
//					sb.append("&iuml;");
//					break;
//				case 'ô' :
//					sb.append("&ocirc;");
//					break;
//				case 'ö' :
//					sb.append("&ouml;");
//					break;
//				case '÷' :
//					sb.append("&#247;");
//					break;
//				case 'ø' :
//					sb.append("&oslash;");
//					break;
//				case 'ù' :
//					sb.append("&ugrave;");
//					break;
//				case 'û' :
//					sb.append("&ucirc;");
//					break;
//				case 'ü' :
//					sb.append("&uuml;");
//					break;
//				case 'ƒ' :
//					sb.append("&fnof;");
//					break;
//				case 'ˆ' :
//					sb.append("&circ;");
//					break;
//				case '˜' :
//					sb.append("&tilde;");
//					break;
//				case '?' :
//					sb.append("&Gamma;");
//					break;
//				case '?' :
//					sb.append("&Delta;");
//					break;
//				case '?' :
//					sb.append("&Theta;");
//					break;
//				case '?' :
//					sb.append("&Lambda;");
//					break;
//				case '?' :
//					sb.append("&Xi;");
//					break;
//				case '?' :
//					sb.append("&Pi;");
//					break;
//				case '?' :
//					sb.append("&Sigma;");
//					break;
//				case '?' :
//					sb.append("&Phi;");
//					break;
//				case '?' :
//					sb.append("&Psi;");
//					break;
//				case '?' :
//					sb.append("&Omega;");
//					break;
//				case '?' :
//					sb.append("&alpha;");
//					break;
//				case '?' :
//					sb.append("&szlig;");
//					break;
//				case '?' :
//					sb.append("&gamma;");
//					break;
//				case '?' :
//					sb.append("&delta;");
//					break;
//				case '?' :
//					sb.append("&epsilon;");
//					break;
//				case '?' :
//					sb.append("&eta;");
//					break;
//				case '?' :
//					sb.append("&theta;");
//					break;
//				case '?' :
//					sb.append("&iota;");
//					break;
//				case '?' :
//					sb.append("&kappa;");
//					break;
//				case '?' :
//					sb.append("&lambda;");
//					break;
//				case '?' :
//					sb.append("&mu;");
//					break;
//				case '?' :
//					sb.append("&nu;");
//					break;
//				case '?' :
//					sb.append("&pi;");
//					break;
//				case '?' :
//					sb.append("&sigma;");
//					break;
//				case '?' :
//					sb.append("&tau;");
//					break;
//				case '?' :
//					sb.append("&upsilon;");
//					break;
//				case '?' :
//					sb.append("&phi;");
//					break;
//				case '?' :
//					sb.append("&psi;");
//					break;
//				case '’' :
//					sb.append("&rsquo;");
//					break;
//				case '“' :
//					sb.append("&ldquo;");
//					break;
//				case '”' :
//					sb.append("&rdquo;");
//					break;
//				case '†' :
//					sb.append("&dagger;");
//					break;
//				case '•' :
//					sb.append("&bull;");
//					break;
//				case '‹' :
//					sb.append("&lsaquo;");
//					break;
//				case '›' :
//					sb.append("&rsaquo;");
//					break;
//				case '?' :
//					sb.append("&oline;");
//					break;
//				case '€' :
//					sb.append("&euro;");
//					break;
//				case '™' :
//					sb.append("&trade;");
//					break;
//				case '?' :
//					sb.append("&Omega;");
//					break;
//				case '?' :
//					sb.append("&larr;");
//					break;
//				case '?' :
//					sb.append("&uarr;");
//					break;
//				case '?' :
//					sb.append("&rarr;");
//					break;
//				case '?' :
//					sb.append("&darr;");
//					break;
//				case '?' :
//					sb.append("&harr;");
//					break;
//				case '?' :
//					sb.append("&crarr;");
//					break;
//				case '?' :
//					sb.append("&forall;");
//					break;
//				case '?' :
//					sb.append("&part;");
//					break;
//				case '?' :
//					sb.append("&exist;");
//					break;
//				case '?' :
//					sb.append("&empty;");
//					break;
//				case '?' :
//					sb.append("&nabla;");
//					break;
//				case '?' :
//					sb.append("&isin;");
//					break;
//				case '?' :
//					sb.append("&notin;");
//					break;
//				case '?' :
//					sb.append("&ni;");
//					break;
//				case '?' :
//					sb.append("&prod;");
//					break;
//				case '?' :
//					sb.append("&sum;");
//					break;
//				case '?' :
//					sb.append("&radic;");
//					break;
//				case '?' :
//					sb.append("&prop;");
//					break;
//				case '?' :
//					sb.append("&infin;");
//					break;
//				case '?' :
//					sb.append("&ang;");
//					break;
//				case '?' :
//					sb.append("&ang;");
//					break;
//				case '?' :
//					sb.append("&or;");
//					break;
//				case '?' :
//					sb.append("&cap;");
//					break;
//				case '?' :
//					sb.append("&cup;");
//					break;
//				case '?' :
//					sb.append("&int;");
//					break;
//				case '?' :
//					sb.append("&there4;");
//					break;
//				case '?' :
//					sb.append("&cong;");
//					break;
//				case '?' :
//					sb.append("&le;");
//					break;
//				case '?' :
//					sb.append("&ge;");
//					break;
//				case '?' :
//					sb.append("&sub;");
//					break;
//				case '?' :
//					sb.append("&sup;");
//					break;
//				case '?' :
//					sb.append("&nsub;");
//					break;
//				case '?' :
//					sb.append("&sube;");
//					break;
//				case '?' :
//					sb.append("&supe;");
//					break;
//				case '?' :
//					sb.append("&oplus;");
//					break;
//				case '?' :
//					sb.append("&otimes;");
//					break;
//				case '?' :
//					sb.append("&perp;");
//					break;
//				case '?' :
//					sb.append("&sdot;");
//					break;
//				default :
//					sb.append(c);
//			}
//		}
//
//		return sb.toString();
//	}
}