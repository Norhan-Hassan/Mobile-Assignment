using EnterpriseMobileApp_ASS1.Dto;
using EnterpriseMobileApp_ASS1.DTO;
using EnterpriseMobileApp_ASS1.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class StudentController : ControllerBase
{
    private readonly IStudentService _StudentService;

    public StudentController(IStudentService StudentService)
    {
        _StudentService = StudentService;
        //_hostingEnvironment = hostingEnvironment;
    }

    [HttpPost("signup")]
    public async Task<IActionResult> SignUpTourist([FromBody] StudentRegisterDto touristDTO)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Call the service to sign up the tourist
            var isSignedUp = await _StudentService.SignUp(touristDTO);

            if (isSignedUp)
            {
                return Ok("Tourist registered successfully!");
            }
            else
            {
                return StatusCode(500, "Failed to register tourist. Please try again later.");
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [HttpPost("signin")]
    public async Task<IActionResult> SignIn([FromBody] StudentLoginDto loginDto)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Call the service to sign in the user
            var isSignedIn = await _StudentService.SignIn(loginDto);

            if (isSignedIn)
            {
                return Ok("Sign-in successful!");
            }
            else
            {
                return Unauthorized("Invalid email or password.");
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [HttpPost("GetStudInfo/{studentname}")]
    public  IActionResult GetStudInfo(  string studentname)
    {
        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            
            var studentInfo = _StudentService.GetStudentInfo(studentname);

            if (studentInfo != null)
            {
                return Ok(studentInfo );
            }
            else
            {
                return Unauthorized("Invalid student name.");
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
}