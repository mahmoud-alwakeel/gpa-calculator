

enum Grade {
  APlus,
  A,
  AMinus,
  BPlus,
  B,
  BMinus,
  CPlus,
  C,
  CMinus,
  DPlus,
  D,
  F,
}

  extension GradeDisplay on Grade {
    String get display {
      switch(this) {
        case Grade.APlus:
          return 'A+';
        case Grade.A:
          return 'A';
        case Grade.AMinus:
          return 'A-';
        case Grade.BPlus:
          return 'B+';
        case Grade.B:
          return 'B';
        case Grade.BMinus:
          return 'B-';
        case Grade.CPlus:
          return 'C+';
        case Grade.C:
          return 'C';
        case Grade.CMinus:
          return 'C-';
        case Grade.DPlus:
          return 'D+';
        case Grade.D:
          return 'D';
        case Grade.F:
          return 'F';
      }
    }
  }
