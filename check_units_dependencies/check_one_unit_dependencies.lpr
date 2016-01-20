{ -*- compile-command: "./check_units_dependencies.sh" -*- }

uses Classes, SysUtils,
  CastleParameters, CastleStringUtils;

  function DependencyOk(CurrentCategory, DependencyCategory: string): boolean;

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
      ( (CurrentCategory = 'base') and (DependencyCategory = 'net') ) or
      ( (CurrentCategory = 'net' ) and (DependencyCategory = 'base') ) or
      // TODO: not nice dependency, it would be good to get rid of this:
      ( (CurrentCategory = 'net' ) and (DependencyCategory = 'images') ) or
      IndirectDependencyCheck('audio', 'net') or
      IndirectDependencyCheck('audio', 'base') or
      IndirectDependencyCheck('images', 'net') or
      IndirectDependencyCheck('images', 'base') or
      IndirectDependencyCheck('fonts', 'images') or
      IndirectDependencyCheck('ui', 'audio') or
      IndirectDependencyCheck('ui', 'fonts') or
      IndirectDependencyCheck('services', 'ui') or
      IndirectDependencyCheck('3d', 'services') or
      IndirectDependencyCheck('castlescript', '3d') or
      IndirectDependencyCheck('x3d', 'castlescript') or
      ( (CurrentCategory = 'x3d' ) and (DependencyCategory = 'game') ) or
      IndirectDependencyCheck('game', 'x3d') or
      IndirectDependencyCheck('window', 'game') or
      IndirectDependencyCheck('components', 'game');
  end;

var
  AllCgeUnits: TStringList;
  DependenciesToCheck: TStringList;

  function ExtractCategory(UnitPath: string): string;
  begin
    while SCharIs(UnitPath, 1, '.') or
          SCharIs(UnitPath, 1, '/') do
      UnitPath := SEnding(UnitPath, 2); // cut off initial ./ from UnitPath
    Result := NextTokenOnce(UnitPath, 1, ['/', '\']);
  end;

  function FindCategory(const DependencyBaseName: string): string;
  var
    UnitPath: string;
  begin
    for UnitPath in AllCgeUnits do
      if SameText(ChangeFileExt(ExtractFileName(UnitPath), ''), DependencyBaseName) then
        Exit(ExtractCategory(UnitPath));
    Exit('');
  end;

var
  CurrentUnit, DependencyToCheck, CurrentCategory, DependencyCategory, DependencyDescribe: string;
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
      DependencyCategory := FindCategory(DependencyToCheck);
      if DependencyCategory <> '' then
      begin
        CurrentCategory := ExtractCategory(CurrentUnit);
        DependencyDescribe := CurrentCategory + ' uses ' + DependencyCategory + ' (unit ' + CurrentUnit + ' uses ' + DependencyToCheck + ')';
        // Writeln('Checking: ', DependencyDescribe);
        if not DependencyOk(CurrentCategory, DependencyCategory) then
          Writeln('NOT ALLOWED DEPENDENCY: ', DependencyDescribe);
      end;
    end;
  finally
    FreeAndNil(AllCgeUnits);
    FreeAndNil(DependenciesToCheck);
  end;
end.
