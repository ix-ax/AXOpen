// Build
// Copyright (c) 2023 MTS spol. s r.o.,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/ix/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/ix/blob/master/notices.md

using System;

public class TestFailedException : Exception
{
    public TestFailedException()
    {
        
    }
    
    public TestFailedException(string message) : base(message)
    {
        var lastColor = Console.ForegroundColor;
        Console.ForegroundColor = ConsoleColor.Red;
        Console.WriteLine(message);
        Console.ForegroundColor = lastColor;
    }
    
}