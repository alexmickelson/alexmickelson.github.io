---
layout: default
banner: main
title:  "Railway Pattern"
---

# Railway Pattern

Also Know as Railway Oriented Programming

## The problem

Whenever a program throws an exception it expects whoever called it to be ready to appropriately catch the error. The code we write has no control over who calls it. We do, however, have control over the code that we call. The Railway Pattern is a way to send error handling down the call stack (to code you control) instead of throwing exceptions up the call stack (to code you don't control).

## What is it?

The Railway Pattern is when every function in your code has 2 paths: A happy path, and a failure path.

Requirements for Railway Pattern:
- Every function recieves both happy and failure input
- Failure input returned unchanged
- Buisness is performed on happy input

Imagine two parallel railways

<!-- ![[Two Railways](https://fsharpforfunandprofit.com/rop/)](/assets/images/railway_pattern.png "Two Railways") -->
<img src="/assets/images/railway_pattern.png"
     alt="Two Railways https://fsharpforfunandprofit.com/rop/"
     class="articleImage" />

If you are ever on the green railway and detect some error or invalid state you can move to the red railway. Now you can handle errors elegantly without throwing exceptions!

## Level 1 - Result class with if statements


#### In use

{% highlight csharp %}
public async Task<IActionResult> OnPostUploadAsync(SongUploadRequest request)
{
    Result<SongUploadRequest> validRequest = request.ValidateRequest();
    Result<Song> song = WriteToFileSystem(validRequest);
    Result<bool> success = StoreSongInDatabase(song);
    return HttpResponse(success);
}
{% endhighlight %}

#### Result Generic Class

{% highlight csharp %}
public struct Result<T>
{
    public readonly bool IsFailure => !IsSucccess;
    public readonly bool IsSucccess;
    public readonly T state;
    public readonly string error;

    private Result(bool IsSucccess, T state, string error)
    {
        this.IsSucccess = IsSucccess;
        this.state = state;
        this.error = error;
    }

    public static Result<T> Success(T state) => new Result<T>(true, state, null);
    public static Result<T> Failure(string error) => new Result<T>(false, default(T), error);
}
{% endhighlight %}

#### Private Functions With If Statements

{% highlight csharp %}
private Result<SongUploadRequest> ValidateRequest(SongUploadRequest request)
{
    return Result<SongUploadRequest>.Success(request);
}

private Result<Song> WriteToFileSystem(Result<SongUploadRequest> result)
{
    if (result.IsSucccess)
    {
        var songGuid = songFileService.WriteNewSongFile(result.state.SongFile);
        var song = new Song()
        {
            SongId = songGuid,
            SongName = result.state.SongName,
            SongPath = ""
        };
        return Result<Song>.Success(song);
    }
    else
    {
        return Result<Song>.Failure(result.error);
    }
}

private Result<bool> StoreSongInDatabase(Result<Song> result)
{
    if(result.IsSucccess)
    {
        await songRepository.StoreSong(result.state);
        return Result<bool>.Success(true);
    }
    else
    {
        return Result<bool>.Failure(result.error);
    }
}

private IActionResult ToHttpResponse(Result<bool> result)
{
    if (result.IsSucccess)
    {
        return new OkResult();
    }
    else
    {
        return new BadRequestObjectResult(result.error);
    }
}
{% endhighlight %}

## Level 2 - Functional

#### Result Class and Result Helper Class

{% highlight csharp %}
public struct Result<T>
{
    public readonly bool IsFailure => !IsSucccess;
    public readonly bool IsSucccess;
    public readonly T state;
    public readonly string error;

    private Result(bool IsSucccess, T state, string error)
    {
        this.IsSucccess = IsSucccess;
        this.state = state;
        this.error = error;
    }

    public static Result<T> Success(T state) => new Result<T>(true, state, null);
    public static Result<T> Failure(string error) => new Result<T>(false, default(T), error);

}
public static class ResultHelper
{
    public static Result<T> Validate<T>(this T state, Func<T, Result<T>> func) 
    {
        return func(state);
    }

    public static async Task<U> Finally<U, T>(this Task<Result<T>> result, Func<Result<T>, U> func)
    {
        await result;
        return func(result.Result);
    }

    public static U Finally<U, T>(this Result<T> result, Func<Result<T>, U> func)
    {
        return func(result);
    }

    public static Result<U> Apply<U, T>(this Result<T> result, Func<T, Result<U>> func)
    {
        if(result.IsSucccess)
        {
            return func(result.state);
        }
        else
        {
            return Result<U>.Failure(result.error);
        }
    }
    public static async Task<Result<U>> Apply<U, T>(this Result<T> result, Func<T, Task<Result<U>>> func)
    {
        if(result.IsSucccess)
        {
            return await func(result.state);
        }
        else
        {
            return Result<U>.Failure(result.error);
        }
    }
    public static async Task<Result<U>> Apply<U, T>(this Task<Result<T>> task, Func<T, Task<Result<U>>> func)
    {
        await task;
        if(task.Result.IsSucccess)
        {
            return await func(task.Result.state);
        }
        else
        {
            return Result<U>.Failure(task.Result.error);
        }
    }
}
{% endhighlight %}

#### In use

{% highlight csharp %}
public async Task<IActionResult> Upload(SongUploadRequest request) =>
    await request
        .Validate(validateSongUploadRequest)
        .Apply(writeSongToFileSystem)
        .Apply(storeSongInDatabaseAsync)
        .Finally(toHttpResponse);
{% endhighlight %}

#### Private Class Functions

{% highlight csharp %}
private async Task<Result<Song>> writeSongToFileSystem(SongUploadRequest songUploadRequest)
{
    var result = await _songFileService.WriteNewSongFile(songUploadRequest.SongFile);
    return result.IsSucccess
        ? Result<Song>.Success(new Song(result.state, songUploadRequest.SongName))
        : Result<Song>.Failure(result.error);
}

private async Task<Result<bool>> storeSongInDatabaseAsync(Song song)
{
    await _songRepository.StoreSong(song);
    return Result<bool>.Success(true);
}

private Result<SongUploadRequest> validateSongUploadRequest(SongUploadRequest uploadRequest)
{
    if (uploadRequest.SongName.Length > 50)
    {
        return Result<SongUploadRequest>.Failure("Song name too long");
    }
    var fiveMbInBytes = 5_000_000;
    if (uploadRequest.SongFile.Length > fiveMbInBytes)
    {
        return Result<SongUploadRequest>.Failure("File too large");
    }
    return Result<SongUploadRequest>.Success(uploadRequest);
}

private IActionResult toHttpResponse(Result<bool> result)
{
    if (result.IsSucccess)
    {
        return new OkResult();
    }
    else
    {
        return new BadRequestObjectResult(result.error);
    }
}
{% endhighlight %}



#### Helper Methods

{% highlight csharp %}
public static class SongHelpers
{
    public static Result<SongUploadRequest> ValidateRequest(this SongUploadRequest request)
    {
        return Result<SongUploadRequest>.Success(request);
    }

    public static async Task<IActionResult> ToHttpResponse(this Task<Result<bool>> task)
    {
        await task;
        if (task.Result.IsSucccess)
        {
            return new OkResult();
        }
        else
        {
            return new BadRequestObjectResult(task.Result.error);
        }
    }
}
{% endhighlight %}








## Excersize

Your task is to write a UserService class 

{% highlight csharp %}
public class UserRegistrationRequest
{
    public string username { get; set; }
    public string email { get; set; }
}
{% endhighlight %}
{% highlight csharp %}
public class UserService
{
    public bool Register(UserRegistrationRequest userRegistrationRequest)
}
{% endhighlight %}

Each of you functions in the UserService class should return and recieve a Result\<T>


1. Your function should recieve a UserRegistrationRequest object with a
   - username
   - email
2. You should validate the userResigtration object
   - The username should be less than 10 characters
   - The email should have one @ character
3. You should check if the user already exists
   - If the username starts with 'c' assume the user already exists
4. You should save the user to the database
5. If you are successfull return a true, otherwise return false




#### Additional Resources

<https://fsharpforfunandprofit.com/rop/>

<https://medium.com/@naveenkumarmuguda/railway-oriented-programming-a-powerful-functional-programming-pattern-ab454e467f31>

<https://proandroiddev.com/railway-oriented-programming-in-kotlin-f1bceed399e5>

<https://github.com/ecourtenay/ROP>

<https://en.wikipedia.org/wiki/Template_method_pattern>
