FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
LABEL stage=build-env
WORKDIR /app

# Copy and build
#COPY ./src /app

#RUN git init
#RUN git config --get https://github.com/KrzysztofPajak/grandnode2-1
RUN git clone git://github.com/KrzysztofPajak/grandnode2-1
RUN cd grandnode2-1
#COPY ./grandnode2-1 /app
#RUN cd samtools

# build plugins
RUN dotnet build /grandnode2-1/Plugins/Authentication.Facebook -c Release
RUN dotnet build /grandnode2-1/Plugins/Authentication.Google -c Release
RUN dotnet build /grandnode2-1/Plugins/DiscountRules.Standard -c Release
RUN dotnet build /grandnode2-1/Plugins/ExchangeRate.McExchange -c Release
RUN dotnet build /grandnode2-1/Plugins/Payments.BrainTree -c Release
RUN dotnet build /grandnode2-1/Plugins/Payments.CashOnDelivery -c Release
RUN dotnet build /grandnode2-1/Plugins/Payments.PayPalStandard -c Release
RUN dotnet build /grandnode2-1/Plugins/Shipping.ByWeight -c Release
RUN dotnet build /grandnode2-1/Plugins/Shipping.FixedRateShipping -c Release
RUN dotnet build /grandnode2-1/Plugins/Shipping.ShippingPoint -c Release
RUN dotnet build /grandnode2-1/Plugins/Tax.CountryStateZip -c Release
RUN dotnet build /grandnode2-1/Plugins/Tax.FixedRate -c Release
RUN dotnet build /grandnode2-1/Plugins/Widgets.FacebookPixel -c Release
RUN dotnet build /grandnode2-1/Plugins/Widgets.GoogleAnalytics -c Release
RUN dotnet build /grandnode2-1/Plugins/Widgets.Slider -c Release

# build Web
RUN dotnet publish /grandnode2-1/Web/Grand.Web -c Release -o ./build/release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
EXPOSE 80
ENV ASPNETCORE_URLS http://+:80
WORKDIR /app
COPY --from=build-env /app/build/release .
ENTRYPOINT ["dotnet", "Grand.Web.dll"]
