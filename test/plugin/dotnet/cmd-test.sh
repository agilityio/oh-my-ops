_do_plugin "dotnet"


function test_cli() {
  local dir
  dir=$(_do_dir_random_tmp_dir)

  _do_repo_dir_add "${dir}" "fakerepo"
  {
    cd "$dir" &&
    echo '
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>netcoreapp3.0</TargetFramework>
  </PropertyGroup>

</Project>
' > "${dir}/fakerepo.csproj" &&
  echo '
using System;

namespace console
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
  ' > "${dir}/Program.cs"
  } || _do_assert_fail

  _do_dotnet_cli 'fakerepo'

  # Test all base commands
  do-fakerepo-dotnet-help || _do_assert_fail
  do-fakerepo-dotnet-clean || _do_assert_fail
  do-fakerepo-dotnet-install || _do_assert_fail
  do-fakerepo-dotnet-build || _do_assert_fail
  do-fakerepo-dotnet-test || _do_assert_fail
}
