/*
 *字符串工具类
 */
class StringTools {
  static Map<String, String> letter = {
    "1": "A",
    "2": "B",
    "3": "C",
    "4": "D",
    "5": "E",
    "6": "F",
    "7": "G",
    "8": "H",
    "9": "I",
    "10": "J",
    "11": "K",
    "12": "L",
    "13": "M",
    "14": "N",
    "15": "O",
    "16": "P",
    "17": "Q",
    "18": "R",
    "19": "S",
    "20": "T",
  };

  /*
   * 转字母符号
   */
  static String toLetter(int? count) {
    if (count != null && letter.length >= count) {
      return letter[count.toString()] ?? "";
    }
    return "";
  }

  /*
   * 去除标点符号 保留空格
   */
  static String? wipe(String? a) {
    if (a != null) {
      return a.replaceAll(RegExp(r"[^\s\w]"), '');
    } else {
      return a;
    }
  }

  /*
   * 将a和b转换为小写后进行比较
   */
  static int compareIgnoreCase(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  /*
   *如果a和b在转换为小写后相等，或都为null，则返回true。
   */
  static bool equalsIgnoreCase(String? a, String? b) =>
      (a == null && b == null) ||
      (a != null && b != null && a.toLowerCase() == b.toLowerCase());

  /*
   *如果a和b在转换为小写后包含比较，或都为null，则返回true。
   */
  static bool containIgnoreCase(String? a, String? b) =>
      (a == null && b == null) ||
      (a != null && b != null && a.toLowerCase().contains(b.toLowerCase()));

  /*
   * 是否为空或空字符串
   */
  static bool isBlank(String? s) {
    return s == null || s.trim().isEmpty;
  }

  /*
   * 符文是否为一个数字
   */
  static bool isDigit(int rune) => rune ^ 0x30 <= 9;

  /*
   *  是否为空
   */
  static bool isEmpty(String? s) => s == null || s.isEmpty;

  /*
   * 是否不为空
   */
  static bool isNotEmpty(String? s) => s != null && s.isNotEmpty;
}
