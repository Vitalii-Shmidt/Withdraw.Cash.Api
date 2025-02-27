using FluentValidation;
using Microsoft.Extensions.Configuration;

namespace Withdraw.Cash.Api;

public static class DI
{
    public static IServiceCollection AddPresentation(this IServiceCollection services)
    {
        //services.AddValidatorsFromAssembly(typeof(DI).Assembly);

        return services;
    }
}
