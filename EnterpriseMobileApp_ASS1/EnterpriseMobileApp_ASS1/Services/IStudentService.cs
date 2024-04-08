using System.Security.Cryptography;
using EnterpriseMobileApp_ASS1.Dto;
using EnterpriseMobileApp_ASS1.DTO;
using Microsoft.AspNetCore.Mvc;

namespace EnterpriseMobileApp_ASS1.Services
{
    

    public interface IStudentService
    {
        Task<bool> SignUp(StudentRegisterDto registerDto);
        Task<bool> SignIn(StudentLoginDto loginDto);
        public StudentInfoDto GetStudentInfo(string studentName);
        public string GetBaseUrl();
    }
}

