{*
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2015 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{if !isset($addresses_style)}
    {$addresses_style.company = 'address_company'}
    {$addresses_style.vat_number = 'address_company'}
    {$addresses_style.firstname = 'address_name'}
    {$addresses_style.lastname = 'address_name'}
    {$addresses_style.address1 = 'address_address1'}
    {$addresses_style.address2 = 'address_address2'}
    {$addresses_style.city = 'address_city'}
    {$addresses_style.country = 'address_country'}
    {$addresses_style.phone = 'address_phone'}
    {$addresses_style.phone_mobile = 'address_phone_mobile'}
    {$addresses_style.alias = 'address_title'}
{/if}
{assign var='have_non_virtual_products' value=false}
{foreach $products as $product}
    {if $product.is_virtual == 0}
        {assign var='have_non_virtual_products' value=true}
        {break}
    {/if}
{/foreach}

<h2>{l s='Payment Options'}</h2>
<!-- HOOK_ADVANCED_PAYMENT -->
<div id="HOOK_ADVANCED_PAYMENT">
    <div class="row">
    <!-- Should get a collection of "PaymentOption" object -->
    {if $HOOK_ADVANCED_PAYMENT }
        {foreach $HOOK_ADVANCED_PAYMENT as $advanced_payment_opt_list}
            {foreach $advanced_payment_opt_list as $paymentOption}
                <div class="col-xs-12 col-md-12">
                    <p class="payment_module">
                        <a>
                            <img src="{$paymentOption->getLogo()}"/>
                            <input name="payment_option" data-payment-option-name="{$paymentOption->getModuleName()}" data-payment-action="{$paymentOption->getAction()}"
                                   type="radio" value="{$paymentOption->getModuleName()}">
                            {$paymentOption->getCallToActionText()}
                        </a>
                        {$paymentOption->getForm()}
                    </p>
                </div>
            {/foreach}
        {/foreach}
    </div>
    {else}
        <p class="alert alert-warning">{l s='Unable to find any available payment option for your cart. Please contact us if the problem persists'}</p>
    {/if}
</div>
<!-- end HOOK_ADVANCED_PAYMENT -->

<h2>{l s='Address(es) Details'}</h2>
{if ((!empty($delivery_option) AND !isset($virtualCart)) OR $delivery->id OR $invoice->id)}
    <div class="order_delivery clearfix row">
        {if !isset($formattedAddresses) || (count($formattedAddresses.invoice) == 0 && count($formattedAddresses.delivery) == 0) || (count($formattedAddresses.invoice.formated) == 0 && count($formattedAddresses.delivery.formated) == 0)}
            {if $delivery->id}
                <div class="col-xs-12 col-sm-6"{if !$have_non_virtual_products} style="display: none;"{/if}>
                    <ul id="delivery_address" class="address item box">
                        <li><h3 class="page-subheading">{l s='Delivery address'}&nbsp;<span class="address_alias">({$delivery->alias})</span></h3></li>
                        {if $delivery->company}<li class="address_company">{$delivery->company|escape:'html':'UTF-8'}</li>{/if}
                        <li class="address_name">{$delivery->firstname|escape:'html':'UTF-8'} {$delivery->lastname|escape:'html':'UTF-8'}</li>
                        <li class="address_address1">{$delivery->address1|escape:'html':'UTF-8'}</li>
                        {if $delivery->address2}<li class="address_address2">{$delivery->address2|escape:'html':'UTF-8'}</li>{/if}
                        <li class="address_city">{$delivery->postcode|escape:'html':'UTF-8'} {$delivery->city|escape:'html':'UTF-8'}</li>
                        <li class="address_country">{$delivery->country|escape:'html':'UTF-8'} {if $delivery_state}({$delivery_state|escape:'html':'UTF-8'}){/if}</li>
                    </ul>
                </div>
            {/if}
            {if $invoice->id}
                <div class="col-xs-12 col-sm-6">
                    <ul id="invoice_address" class="address alternate_item box">
                        <li><h3 class="page-subheading">{l s='Invoice address'}&nbsp;<span class="address_alias">({$invoice->alias})</span></h3></li>
                        {if $invoice->company}<li class="address_company">{$invoice->company|escape:'html':'UTF-8'}</li>{/if}
                        <li class="address_name">{$invoice->firstname|escape:'html':'UTF-8'} {$invoice->lastname|escape:'html':'UTF-8'}</li>
                        <li class="address_address1">{$invoice->address1|escape:'html':'UTF-8'}</li>
                        {if $invoice->address2}<li class="address_address2">{$invoice->address2|escape:'html':'UTF-8'}</li>{/if}
                        <li class="address_city">{$invoice->postcode|escape:'html':'UTF-8'} {$invoice->city|escape:'html':'UTF-8'}</li>
                        <li class="address_country">{$invoice->country|escape:'html':'UTF-8'} {if $invoice_state}({$invoice_state|escape:'html':'UTF-8'}){/if}</li>
                    </ul>
                </div>
            {/if}
        {else}
            {foreach from=$formattedAddresses key=k item=address}
                <div class="col-xs-12 col-sm-6"{if $k == 'delivery' && !$have_non_virtual_products} style="display: none;"{/if}>
                    <ul class="address {if $address@last}last_item{elseif $address@first}first_item{/if} {if $address@index % 2}alternate_item{else}item{/if} box">
                        <li>
                            <h3 class="page-subheading">
                                {if $k eq 'invoice'}
                                    {l s='Invoice address'}
                                {elseif $k eq 'delivery' && $delivery->id}
                                    {l s='Delivery address'}
                                {/if}
                                {if isset($address.object.alias)}
                                    <span class="address_alias">({$address.object.alias})</span>
                                {/if}
                            </h3>
                        </li>
                        {foreach $address.ordered as $pattern}
                            {assign var=addressKey value=" "|explode:$pattern}
                            {assign var=addedli value=false}
                            {foreach from=$addressKey item=key name=foo}
                                {$key_str = $key|regex_replace:AddressFormat::_CLEANING_REGEX_:""}
                                {if isset($address.formated[$key_str]) && !empty($address.formated[$key_str])}
                                    {if (!$addedli)}
                                        {$addedli = true}
                                        <li><span class="{if isset($addresses_style[$key_str])}{$addresses_style[$key_str]}{/if}">
                                    {/if}
                                    {$address.formated[$key_str]|escape:'html':'UTF-8'}
                                {/if}
                                {if ($smarty.foreach.foo.last && $addedli)}
                                    </span></li>
                                {/if}
                            {/foreach}
                        {/foreach}
                    </ul>
                </div>
            {/foreach}
        {/if}
    </div>
{/if}

<h2>{l s='Terms and Conditions'}</h2>
<!-- TNC -->
{if $conditions AND $cms_id}
    {if $override_tos_display }
        {$override_tos_display}
    {else}
        <div class="box">
            <p class="carrier_title">{l s='Terms of service'}</p>
            <p class="checkbox">
                <input type="checkbox" name="cgv" id="cgv" value="1" {if $checkedTOS}checked="checked"{/if} />
                <label for="cgv">{l s='I agree to the terms of service and will adhere to them unconditionally.'}</label>
                <a href="{$link_conditions|escape:'html':'UTF-8'}" class="iframe" rel="nofollow">{l s='(Read the Terms of Service)'}</a>
            </p>
        </div>
    {/if}
{/if}
<!-- end TNC -->

<h2>{l s='Cart Summary'}</h2>
{assign var='total_discounts_num' value="{if $total_discounts != 0}1{else}0{/if}"}
{assign var='use_show_taxes' value="{if $use_taxes && $show_taxes}2{else}0{/if}"}
{assign var='total_wrapping_taxes_num' value="{if $total_wrapping != 0}1{else}0{/if}"}
{* eu-legal *}
{hook h="displayBeforeShoppingCartBlock"}
<div id="order-detail-content" class="table_block table-responsive">
    <table id="cart_summary" class="table table-bordered {if $PS_STOCK_MANAGEMENT}stock-management-on{else}stock-management-off{/if}">
        <thead>
        <tr>
            <th class="cart_product first_item">{l s='Product'}</th>
            <th class="cart_description item">{l s='Description'}</th>
            {if $PS_STOCK_MANAGEMENT}
                {assign var='col_span_subtotal' value='3'}
                <th class="cart_avail item text-center">{l s='Availability'}</th>
            {else}
                {assign var='col_span_subtotal' value='2'}
            {/if}
            <th class="cart_unit item text-right">{l s='Unit price'}</th>
            <th class="cart_quantity item text-center">{l s='Qty'}</th>
            <th colspan="{$col_span_subtotal}" class="cart_total item text-right">{l s='Total'}</th>
        </tr>
        </thead>
        <tfoot>
        {assign var='rowspan_total' value=2+$total_discounts_num+$total_wrapping_taxes_num}

        {if $use_taxes && $show_taxes && $total_tax != 0}
            {assign var='rowspan_total' value=$rowspan_total+1}
        {/if}

        {if $priceDisplay != 0}
            {assign var='rowspan_total' value=$rowspan_total+1}
        {/if}

        {if $total_shipping_tax_exc <= 0 && !isset($virtualCart)}
            {assign var='rowspan_total' value=$rowspan_total+1}
        {else}
            {if $use_taxes && $total_shipping_tax_exc != $total_shipping}
                {if $priceDisplay && $total_shipping_tax_exc > 0}
                    {assign var='rowspan_total' value=$rowspan_total+1}
                {elseif $total_shipping > 0}
                    {assign var='rowspan_total' value=$rowspan_total+1}
                {/if}
            {elseif $total_shipping_tax_exc > 0}
                {assign var='rowspan_total' value=$rowspan_total+1}
            {/if}
        {/if}

        {if $use_taxes}
            {if $priceDisplay}
                <tr class="cart_total_price">
                    <td rowspan="{$rowspan_total}" colspan="3" id="cart_voucher" class="cart_voucher">
                        {if $voucherAllowed}
                            {if isset($errors_discount) && $errors_discount}
                                <ul class="alert alert-danger">
                                    {foreach $errors_discount as $k=>$error}
                                        <li>{$error|escape:'html':'UTF-8'}</li>
                                    {/foreach}
                                </ul>
                            {/if}
                            <form action="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" id="voucher">
                                <fieldset>
                                    <h4>{l s='Vouchers'}</h4>
                                    <input type="text" class="discount_name form-control" id="discount_name" name="discount_name" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}" />
                                    <input type="hidden" name="submitDiscount" />
                                    <button type="submit" name="submitAddDiscount" class="button btn btn-default button-small"><span>{l s='OK'}</span></button>
                                </fieldset>
                            </form>
                            {if $displayVouchers}
                                <p id="title" class="title-offers">{l s='Take advantage of our exclusive offers:'}</p>
                                <div id="display_cart_vouchers">
                                    {foreach $displayVouchers as $voucher}
                                        {if $voucher.code != ''}<span class="voucher_name" data-code="{$voucher.code|escape:'html':'UTF-8'}">{$voucher.code|escape:'html':'UTF-8'}</span> - {/if}{$voucher.name}<br />
                                    {/foreach}
                                </div>
                            {/if}
                        {/if}
                    </td>
                    <td colspan="{$col_span_subtotal}" class="text-right">{if $display_tax_label}{l s='Total products (tax excl.)'}{else}{l s='Total products'}{/if}</td>
                    <td colspan="2" class="price" id="total_product">{displayPrice price=$total_products}</td>
                </tr>
            {else}
                <tr class="cart_total_price">
                    <td rowspan="{$rowspan_total}" colspan="2" id="cart_voucher" class="cart_voucher">
                        {if $voucherAllowed}
                            {if isset($errors_discount) && $errors_discount}
                                <ul class="alert alert-danger">
                                    {foreach $errors_discount as $k=>$error}
                                        <li>{$error|escape:'html':'UTF-8'}</li>
                                    {/foreach}
                                </ul>
                            {/if}
                            <form action="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" id="voucher">
                                <fieldset>
                                    <h4>{l s='Vouchers'}</h4>
                                    <input type="text" class="discount_name form-control" id="discount_name" name="discount_name" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}" />
                                    <input type="hidden" name="submitDiscount" />
                                    <button type="submit" name="submitAddDiscount" class="button btn btn-default button-small"><span>{l s='OK'}</span></button>
                                </fieldset>
                            </form>
                            {if $displayVouchers}
                                <p id="title" class="title-offers">{l s='Take advantage of our exclusive offers:'}</p>
                                <div id="display_cart_vouchers">
                                    {foreach $displayVouchers as $voucher}
                                        {if $voucher.code != ''}<span class="voucher_name" data-code="{$voucher.code|escape:'html':'UTF-8'}">{$voucher.code|escape:'html':'UTF-8'}</span> - {/if}{$voucher.name}<br />
                                    {/foreach}
                                </div>
                            {/if}
                        {/if}
                    </td>
                    <td colspan="{$col_span_subtotal}" class="text-right">{if $display_tax_label}{l s='Total products (tax incl.)'}{else}{l s='Total products'}{/if}</td>
                    <td colspan="2" class="price" id="total_product">{displayPrice price=$total_products_wt}</td>
                </tr>
            {/if}
        {else}
            <tr class="cart_total_price">
                <td rowspan="{$rowspan_total}" colspan="2" id="cart_voucher" class="cart_voucher">
                    {if $voucherAllowed}
                        {if isset($errors_discount) && $errors_discount}
                            <ul class="alert alert-danger">
                                {foreach $errors_discount as $k=>$error}
                                    <li>{$error|escape:'html':'UTF-8'}</li>
                                {/foreach}
                            </ul>
                        {/if}
                        <form action="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" id="voucher">
                            <fieldset>
                                <h4>{l s='Vouchers'}</h4>
                                <input type="text" class="discount_name form-control" id="discount_name" name="discount_name" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}" />
                                <input type="hidden" name="submitDiscount" />
                                <button type="submit" name="submitAddDiscount" class="button btn btn-default button-small">
                                    <span>{l s='OK'}</span>
                                </button>
                            </fieldset>
                        </form>
                        {if $displayVouchers}
                            <p id="title" class="title-offers">{l s='Take advantage of our exclusive offers:'}</p>
                            <div id="display_cart_vouchers">
                                {foreach $displayVouchers as $voucher}
                                    {if $voucher.code != ''}<span class="voucher_name" data-code="{$voucher.code|escape:'html':'UTF-8'}">{$voucher.code|escape:'html':'UTF-8'}</span> - {/if}{$voucher.name}<br />
                                {/foreach}
                            </div>
                        {/if}
                    {/if}
                </td>
                <td colspan="{$col_span_subtotal}" class="text-right">{l s='Total products'}</td>
                <td colspan="2" class="price" id="total_product">{displayPrice price=$total_products}</td>
            </tr>
        {/if}
        <tr{if $total_wrapping == 0} style="display: none;"{/if}>
            <td colspan="3" class="text-right">
                {if $use_taxes}
                    {if $display_tax_label}{l s='Total gift wrapping (tax incl.)'}{else}{l s='Total gift-wrapping cost'}{/if}
                {else}
                    {l s='Total gift-wrapping cost'}
                {/if}
            </td>
            <td colspan="2" class="price-discount price" id="total_wrapping">
                {if $use_taxes}
                    {if $priceDisplay}
                        {displayPrice price=$total_wrapping_tax_exc}
                    {else}
                        {displayPrice price=$total_wrapping}
                    {/if}
                {else}
                    {displayPrice price=$total_wrapping_tax_exc}
                {/if}
            </td>
        </tr>
        {if $total_shipping_tax_exc <= 0 && !isset($virtualCart)}
            <tr class="cart_total_delivery{if !$opc && (!isset($cart->id_address_delivery) || !$cart->id_address_delivery)} unvisible{/if}">
                <td colspan="{$col_span_subtotal}" class="text-right">{l s='Total shipping'}</td>
                <td colspan="2" class="price" id="total_shipping">{l s='Free Shipping!'}</td>
            </tr>
        {else}
            {if $use_taxes && $total_shipping_tax_exc != $total_shipping}
                {if $priceDisplay}
                    <tr class="cart_total_delivery{if $total_shipping_tax_exc <= 0} unvisible{/if}">
                        <td colspan="{$col_span_subtotal}" class="text-right">{if $display_tax_label}{l s='Total shipping (tax excl.)'}{else}{l s='Total shipping'}{/if}</td>
                        <td colspan="2" class="price" id="total_shipping">{displayPrice price=$total_shipping_tax_exc}</td>
                    </tr>
                {else}
                    <tr class="cart_total_delivery{if $total_shipping <= 0} unvisible{/if}">
                        <td colspan="{$col_span_subtotal}" class="text-right">{if $display_tax_label}{l s='Total shipping (tax incl.)'}{else}{l s='Total shipping'}{/if}</td>
                        <td colspan="2" class="price" id="total_shipping" >{displayPrice price=$total_shipping}</td>
                    </tr>
                {/if}
            {else}
                <tr class="cart_total_delivery{if $total_shipping_tax_exc <= 0} unvisible{/if}">
                    <td colspan="{$col_span_subtotal}" class="text-right">{l s='Total shipping'}</td>
                    <td colspan="2" class="price" id="total_shipping" >{displayPrice price=$total_shipping_tax_exc}</td>
                </tr>
            {/if}
        {/if}
        <tr class="cart_total_voucher{if $total_discounts == 0} unvisible{/if}">
            <td colspan="{$col_span_subtotal}" class="text-right">
                {if $display_tax_label}
                    {if $use_taxes && $priceDisplay == 0}
                        {l s='Total vouchers (tax incl.)'}
                    {else}
                        {l s='Total vouchers (tax excl.)'}
                    {/if}
                {else}
                    {l s='Total vouchers'}
                {/if}
            </td>
            <td colspan="2" class="price-discount price" id="total_discount">
                {if $use_taxes && $priceDisplay == 0}
                    {assign var='total_discounts_negative' value=$total_discounts * -1}
                {else}
                    {assign var='total_discounts_negative' value=$total_discounts_tax_exc * -1}
                {/if}
                {displayPrice price=$total_discounts_negative}
            </td>
        </tr>
        {if $use_taxes && $show_taxes && $total_tax != 0 }
            {if $priceDisplay != 0}
                <tr class="cart_total_price">
                    <td colspan="{$col_span_subtotal}" class="text-right">{if $display_tax_label}{l s='Total (tax excl.)'}{else}{l s='Total'}{/if}</td>
                    <td colspan="2" class="price" id="total_price_without_tax">{displayPrice price=$total_price_without_tax}</td>
                </tr>
            {/if}
            <tr class="cart_total_tax">
                <td colspan="{$col_span_subtotal}" class="text-right">{l s='Tax'}</td>
                <td colspan="2" class="price" id="total_tax">{displayPrice price=$total_tax}</td>
            </tr>
        {/if}
        <tr class="cart_total_price">
            <td colspan="{$col_span_subtotal}" class="total_price_container text-right">
                <span>{l s='Total'}</span>
            </td>
            {if $use_taxes}
                <td colspan="2" class="price" id="total_price_container">
                    <span id="total_price">{displayPrice price=$total_price}</span>
                </td>
            {else}
                <td colspan="2" class="price" id="total_price_container">
                    <span id="total_price">{displayPrice price=$total_price_without_tax}</span>
                </td>
            {/if}
        </tr>
        </tfoot>
        <tbody>
        {assign var='odd' value=0}
        {assign var='have_non_virtual_products' value=false}
        {foreach $products as $product}
            {if $product.is_virtual == 0}
                {assign var='have_non_virtual_products' value=true}
            {/if}
            {assign var='productId' value=$product.id_product}
            {assign var='productAttributeId' value=$product.id_product_attribute}
            {assign var='quantityDisplayed' value=0}
            {assign var='odd' value=($odd+1)%2}
            {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId) || count($gift_products)}
            {* Display the product line *}
            {include file="$tpl_dir./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first noDeleteButton=1 cannotModify=1}
            {* Then the customized datas ones*}
            {if isset($customizedDatas.$productId.$productAttributeId)}
                {foreach $customizedDatas.$productId.$productAttributeId[$product.id_address_delivery] as $id_customization=>$customization}
                    <tr
                            id="product_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}"
                            class="product_customization_for_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}{if $odd} odd{else} even{/if} customization alternate_item {if $product@last && $customization@last && !count($gift_products)}last_item{/if}">
                        <td></td>
                        <td colspan="3">
                            {foreach $customization.datas as $type => $custom_data}
                                {if $type == $CUSTOMIZE_FILE}
                                    <div class="customizationUploaded">
                                        <ul class="customizationUploaded">
                                            {foreach $custom_data as $picture}
                                                <li><img src="{$pic_dir}{$picture.value}_small" alt="" class="customizationUploaded" /></li>
                                            {/foreach}
                                        </ul>
                                    </div>
                                {elseif $type == $CUSTOMIZE_TEXTFIELD}
                                    <ul class="typedText">
                                        {foreach $custom_data as $textField}
                                            <li>
                                                {if $textField.name}
                                                    {$textField.name}
                                                {else}
                                                    {l s='Text #'}{$textField@index+1}
                                                {/if}
                                                : {$textField.value}
                                            </li>
                                        {/foreach}
                                    </ul>
                                {/if}
                            {/foreach}
                        </td>
                        <td class="cart_quantity" colspan="1">
                                <span>{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}</span>
                        </td>

                        <td>
                        </td>
                    </tr>
                    {assign var='quantityDisplayed' value=$quantityDisplayed+$customization.quantity}
                {/foreach}

                {* If it exists also some uncustomized products *}
                {if $product.quantity-$quantityDisplayed > 0}{include file="$tpl_dir./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first noDeleteButton=1 cannotModify=1}{/if}
            {/if}
        {/foreach}
        {assign var='last_was_odd' value=$product@iteration%2}
        {foreach $gift_products as $product}
            {assign var='productId' value=$product.id_product}
            {assign var='productAttributeId' value=$product.id_product_attribute}
            {assign var='quantityDisplayed' value=0}
            {assign var='odd' value=($product@iteration+$last_was_odd)%2}
            {assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId)}
            {assign var='cannotModify' value=1}
            {* Display the gift product line *}
            {include file="$tpl_dir./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first noDeleteButton=1 cannotModify=1}
        {/foreach}
        </tbody>
        {if sizeof($discounts)}
            <tbody>
            {foreach $discounts as $discount}
                {if (float)$discount.value_real == 0}
                    {continue}
                {/if}
                <tr class="cart_discount {if $discount@last}last_item{elseif $discount@first}first_item{else}item{/if}" id="cart_discount_{$discount.id_discount}">
                    <td class="cart_discount_name" colspan="{if $PS_STOCK_MANAGEMENT}3{else}2{/if}">{$discount.name}</td>
                    <td class="cart_discount_price">
								<span class="price-discount">
								{if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}
								</span>
                    </td>
                    <td class="cart_discount_delete">1</td>
                    <td class="price_discount_del text-center">
                        {if strlen($discount.code)}
                            <a
                                    href="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}?deleteDiscount={$discount.id_discount}"
                                    class="price_discount_delete"
                                    title="{l s='Delete'}">
                                <i class="icon-trash"></i>
                            </a>
                        {/if}
                    </td>
                    <td class="cart_discount_price">
                        <span class="price-discount price">{if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}</span>
                    </td>
                </tr>
            {/foreach}
            </tbody>
        {/if}
    </table>
</div> <!-- end order-detail-content -->


<p class="cart_navigation clearfix">

    {if $opc}
        {assign var='back_link' value=$link->getPageLink('index')}
    {else}
        {assign var='back_link' value=$link->getPageLink('order', true, NULL, "step=2")}
    {/if}
    <a href="{$back_link|escape:'html':'UTF-8'}" title="{l s='Previous'}" class="button-exclusive btn btn-default">
        <i class="icon-chevron-left"></i>
        {l s='Continue shopping'}
    </a>
    <button data-show-if-js="" style="" id="confirmOrder" type="button" class="button btn btn-default standard-checkout button-medium"><span>{l s='Order With Obligation To Pay'}</span></button>
</p>
