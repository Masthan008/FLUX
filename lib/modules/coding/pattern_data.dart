class PatternData {
  final String name;
  final String output;
  final String code;

  PatternData(this.name, this.output, this.code);
}

class PatternRepository {
  static final List<PatternData> starPatterns = [
    PatternData(
      "Right Triangle",
      '''* 
* * 
* * * 
* * * * 
* * * * * ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Inverted Triangle",
      '''* * * * * 
* * * * 
* * * 
* * 
* ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = rows; i >= 1; i--) {
        for(int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Butterfly Pattern",
      '''*                 * 
* *             * * 
* * *         * * * 
* * * *     * * * * 
* * * * * * * * * * 
* * * *     * * * * 
* * *         * * * 
* *             * * 
*                 * ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    // Upper half
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= i; j++) printf("* ");
        for(int j = 1; j <= 2 * (rows - i); j++) printf("  ");
        for(int j = 1; j <= i; j++) printf("* ");
        printf("\\n");
    }
    // Lower half
    for(int i = rows - 1; i >= 1; i--) {
        for(int j = 1; j <= i; j++) printf("* ");
        for(int j = 1; j <= 2 * (rows - i); j++) printf("  ");
        for(int j = 1; j <= i; j++) printf("* ");
        printf("\\n");
    }
    return 0;
}''',
    ),
  ];

  static final List<PatternData> numberPatterns = [
    PatternData(
      "Floyd's Triangle",
      '''1 
2 3 
4 5 6 
7 8 9 10 
11 12 13 14 15 ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    int num = 1;
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= i; j++) {
            printf("%d ", num);
            num++;
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Pascal's Triangle",
      '''          1
        1   1
      1   2   1
    1   3   3   1
  1   4   6   4   1''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    int coef = 1;
    for(int i = 0; i < rows; i++) {
        for(int space = 1; space <= rows - i; space++) printf("  ");
        for(int j = 0; j <= i; j++) {
            if(j == 0 || i == 0) coef = 1;
            else coef = coef * (i - j + 1) / j;
            printf("%4d", coef);
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "1-2-3 Pyramid",
      '''        1 
      2 3 2 
    3 4 5 4 3 
  4 5 6 7 6 5 4 
5 6 7 8 9 8 7 6 5 ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= rows - i; j++) printf("  ");
        for(int j = i; j < 2 * i; j++) printf("%d ", j);
        for(int j = 2 * i - 2; j >= i; j--) printf("%d ", j);
        printf("\\n");
    }
    return 0;
}''',
    ),
  ];

  static final List<PatternData> alphabetPatterns = [
    PatternData(
      "A-BB-CCC",
      '''A 
B B 
C C C 
D D D D 
E E E E E ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 0; i < rows; i++) {
        for(int j = 0; j <= i; j++) {
            printf("%c ", 'A' + i);
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Alphabet Pyramid",
      '''        A 
      A B A 
    A B C B A 
  A B C D C B A 
A B C D E D C B A ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 0; i < rows; i++) {
        for(int j = 0; j < rows - i - 1; j++) printf("  ");
        for(int j = 0; j <= i; j++) printf("%c ", 'A' + j);
        for(int j = i - 1; j >= 0; j--) printf("%c ", 'A' + j);
        printf("\\n");
    }
    return 0;
}''',
    ),
  ];

  static final List<PatternData> pyramidPatterns = [
    PatternData(
      "Star Pyramid",
      '''        * 
      * * * 
    * * * * * 
  * * * * * * * 
* * * * * * * * * ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= rows - i; j++) printf("  ");
        for(int k = 1; k <= 2*i - 1; k++) printf("* ");
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Diamond",
      '''        * 
      * * * 
    * * * * * 
  * * * * * * * 
* * * * * * * * * 
  * * * * * * * 
    * * * * * 
      * * * 
        * ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    // Upper
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= rows - i; j++) printf("  ");
        for(int k = 1; k <= 2*i - 1; k++) printf("* ");
        printf("\\n");
    }
    // Lower
    for(int i = rows - 1; i >= 1; i--) {
        for(int j = 1; j <= rows - i; j++) printf("  ");
        for(int k = 1; k <= 2*i - 1; k++) printf("* ");
        printf("\\n");
    }
    return 0;
}''',
    ),
  ];

  static final List<PatternData> hollowPatterns = [
    PatternData(
      "Hollow Square",
      '''* * * * * 
*       * 
*       * 
*       * 
* * * * * ''',
      '''#include <stdio.h>

int main() {
    int size = 5;
    for(int i = 1; i <= size; i++) {
        for(int j = 1; j <= size; j++) {
            if(i == 1 || i == size || j == 1 || j == size) printf("* ");
            else printf("  ");
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
    PatternData(
      "Hollow Pyramid",
      '''        * 
      *   * 
    *       * 
  *           * 
* * * * * * * * * ''',
      '''#include <stdio.h>

int main() {
    int rows = 5;
    for(int i = 1; i <= rows; i++) {
        for(int j = 1; j <= rows - i; j++) printf("  ");
        for(int j = 1; j <= 2*i - 1; j++) {
            if(j == 1 || j == 2*i - 1 || i == rows) printf("* ");
            else printf("  ");
        }
        printf("\\n");
    }
    return 0;
}''',
    ),
  ];
}
