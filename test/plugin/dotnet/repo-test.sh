proj_dir=$(_do_proj_default_get_dir)
repo="test-gen"
repo_dir="${proj_dir}/${repo}"

function test_setup() {
    rm -rfd "${repo_dir}"
    # Generates the new dotnet repository
    _do_repo_gen ${repo}
    _do_dir_assert ${repo_dir}

    _do_dotnet_repo_gen "${proj_dir}" "${repo}" || _do_assert_fail
    _do_file_assert "${repo_dir}/dotnet.sln"
}

function test_teardown() {
    # Removes the newly generated dotnet repository
    rm -rfd "${repo_dir}"
}

function test_multi_projs() {
    mkdir ${repo_dir}/proj1
    echo '
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netstandard2.0</TargetFramework>
    <PackOnBuild>true</PackOnBuild>
    <Authors>Test</Authors>
    <PackageId>Do.Proj1</PackageId>
    <Version>1.0.0</Version>
    <Company>AgilityIO</Company>    
  </PropertyGroup>
</Project>
' > ${repo_dir}/proj1/proj1.csproj

    mkdir -p ${repo_dir}/src/proj2
    echo '
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netstandard2.0</TargetFramework>
    <PackOnBuild>true</PackOnBuild>
    <Authors>Test</Authors>
    <PackageId>Do.Proj1</PackageId>
    <Version>1.0.0</Version>
    <Company>AgilityIO</Company>    
  </PropertyGroup>
</Project>
' > ${repo_dir}/src/proj2/proj2.csproj

    # Re-initializes the dotnet repository
    _do_dotnet_repo_init "${proj_dir}" "${repo}"

    # Prints out help
    _do_dotnet_repo_help "${proj_dir}" "${repo}" || _do_assert_fail

    # Makes sure all dotnet aliases at the repository level available.
    _do_alias_assert "test-gen-dotnet-help" 
    _do_alias_assert "test-gen-dotnet-clean"
    _do_alias_assert "test-gen-dotnet-build"
    _do_alias_assert "test-gen-dotnet-test" 

    # Makes sure all dotnet aliaes at the proj1 level available.
    _do_alias_assert "test-gen-dotnet-clean-proj1"
    _do_alias_assert "test-gen-dotnet-build-proj1"
    _do_alias_assert "test-gen-dotnet-test-proj1"

    # Makes sure all dotnet aliaes at the proj2 level available.
    _do_alias_assert "test-gen-dotnet-clean-src-proj2"
    _do_alias_assert "test-gen-dotnet-build-src-proj2"
    _do_alias_assert "test-gen-dotnet-test-src-proj2"

    _do_dotnet_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
    _do_dotnet_repo_build "${proj_dir}" "${repo}" || _do_assert_fail
    _do_dotnet_repo_test "${proj_dir}" "${repo}" || _do_assert_fail

}

function test_help() {
    _do_dotnet_repo_help "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_clean() {
    _do_dotnet_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
    _do_dotnet_repo_clean "${proj_dir}" "${repo}" || _do_assert_fail
}

function test_build() {
    _do_dotnet_repo_build "${proj_dir}" "${repo}" || _do_assert_fail
}
