{ -*- compile-command: "./check_units_dependencies.sh" -*- }

uses Classes, SysUtils,
  CastleParameters, CastleStringUtils;

  { Is it OK to depend from unit in CurrentCategory on a unit in DependencyCategory. }
  function DependencyOk(CurrentCategory, DependencyCategory: string): boolean;

    { Enable depending of a unit from ValidCategory on a unit
      in ValidDependencyCategory.
      Works recursively, so any unit in a category that can depend on
      ValidCategory can also depend on ValidDependencyCategory. }
    function IndirectDependencyCheck(const ValidCategory, ValidDependencyCategory: string): boolean;
    begin
      Result :=
        ( (CurrentCategory = ValidCategory) and (DependencyCategory = ValidDependencyCategory) ) or
        ( (CurrentCategory = ValidCategory) and (DependencyOk(ValidDependencyCategory, DependencyCategory)) );
    end;

  begin
    CurrentCategory := LowerCase(CurrentCategory);
    DependencyCategory := LowerCase(DependencyCategory);

    Result :=
      (CurrentCategory = DependencyCategory) or
      IndirectDependencyCheck('base', 'compatibility') or
      IndirectDependencyCheck('files', 'base') or
      IndirectDependencyCheck('audio', 'files') or
      IndirectDependencyCheck('images', 'files') or
      IndirectDependencyCheck('fonts', 'images') or
      IndirectDependencyCheck('ui', 'audio') or
      IndirectDependencyCheck('ui', 'fonts') or
      IndirectDependencyCheck('services', 'ui') or
      IndirectDependencyCheck('3d', 'services') or
      IndirectDependencyCheck('castlescript', '3d') or
      IndirectDependencyCheck('x3d', 'castlescript') or
      IndirectDependencyCheck('game', 'x3d') or
      IndirectDependencyCheck('window', 'game') or
      IndirectDependencyCheck('components', 'game');
  end;

var
  AllCgeUnits: TStringList;
  DependenciesToCheck: TStringList;

  procedure ExtractCategory(UnitPath: string;
    out Category: string; out IsOpenGL: boolean);
  var
    TokenPos: Integer;
    PartAfterCategory: string;
  begin
    while SCharIs(UnitPath, 1, '.') or
          SCharIs(UnitPath, 1, '/') do
      UnitPath := SEnding(UnitPath, 2); // cut off initial ./ from UnitPath
    TokenPos := 1;
    Category := NextToken(UnitPath, TokenPos, ['/', '\']);
    PartAfterCategory := NextToken(UnitPath, TokenPos, ['/', '\']);
    IsOpenGL :=
      SameText(PartAfterCategory, 'opengl') or
      // All units in categories below are automatically tied to OpenGL,
      // they don't have to be in opengl/ subdirectory.
      SameText(Category, 'game') or
      SameText(Category, 'window') or
      SameText(Category, 'component');
  end;

  function FindCategory(const DependencyBaseName: string;
    out Category: string; out IsOpenGL: boolean): boolean;
  var
    UnitPath: string;
  begin
    for UnitPath in AllCgeUnits do
      if SameText(ChangeFileExt(ExtractFileName(UnitPath), ''), DependencyBaseName) then
      begin
        ExtractCategory(UnitPath, Category, IsOpenGL);
	Exit(true);
      end;
    Result := false;
  end;

var
  CurrentUnit, DependencyToCheck, CurrentCategory, DependencyCategory, DependencyDescribe: string;
  CurrentIsOpenGL, DependencyIsOpenGL: boolean;
begin
  Parameters.CheckHigh(3);
  AllCgeUnits := TStringList.Create;
  AllCgeUnits.LoadFromFile(Parameters[1]);
  CurrentUnit := Parameters[2];
  DependenciesToCheck := TStringList.Create;
  DependenciesToCheck.Text := Parameters[3];

  try
    for DependencyToCheck in DependenciesToCheck do
    begin
      if FindCategory(DependencyToCheck, DependencyCategory, DependencyIsOpenGL) then
      begin
        ExtractCategory(CurrentUnit, CurrentCategory, CurrentIsOpenGL);
        DependencyDescribe := Format('Category %s (OpenGL subdirectory: %s) uses %s (OpenGL subdirectory: %s). Unit %s uses %s',
	  [CurrentCategory,
	   BoolToStr(CurrentIsOpenGL, true),
	   DependencyCategory,
	   BoolToStr(DependencyIsOpenGL, true),
	   CurrentUnit,
	   DependencyToCheck]);
        // Writeln('Checking: ', DependencyDescribe);
        if not DependencyOk(CurrentCategory, DependencyCategory) then
        begin
          Writeln(ErrOutput, 'ERROR: Not allowed dependency: ', DependencyDescribe);
          ExitCode := 1;
        end;
	if (not CurrentIsOpenGL) and DependencyIsOpenGL then
	begin
          Writeln(ErrOutput, 'ERROR: Not allowed dependency (supposedly non-OpenGL code depends on OpenGL code): ', DependencyDescribe);
          ExitCode := 1;
        end;
      end;
    end;
  finally
    FreeAndNil(AllCgeUnits);
    FreeAndNil(DependenciesToCheck);
  end;
end.
